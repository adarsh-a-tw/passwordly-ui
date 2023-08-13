import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:passwordly/networking/exceptions/api_error.dart';
import 'package:passwordly/networking/passwordly_end_point.dart';
import 'package:passwordly/networking/request_builders/fetch_access_token_builder.dart';
import 'package:passwordly/networking/response_builders/fetch_access_token_response.dart';

class PasswordlyApiClient {
  final String _apiHostUrl;

  final _client = http.Client();

  String? _refreshToken;
  String? _accessToken;
  Timer? _timer;

  Function()? _sessionExpiryCallback;

  PasswordlyApiClient(this._apiHostUrl);

  http.Request configureRequest(
    PasswordlyEndPoint endPoint, {
    String? body,
    bool authNeeded = true,
    Map<String, String>? queryParams,
    Map<String, String>? params,
  }) {
    String parameterisedEndpoint = endPoint.path;
    if (params != null) {
      for (final param in params.entries) {
        parameterisedEndpoint = parameterisedEndpoint.replaceFirst(
          "{:${param.key}}",
          param.value,
        );
      }
    }
    final request = http.Request(
      endPoint.method.rawValue,
      Uri.https(
        _apiHostUrl,
        parameterisedEndpoint,
        queryParams,
      ),
    );
    if (authNeeded) {
      request.headers.addAll({"Authorization": "Bearer $_accessToken"});
    }
    if (body != null) {
      request.headers.addAll({"Content-Type": "application/json"});
      request.body = body;
    }
    return request;
  }

  Future<Map<String, dynamic>> send(http.Request request) async {
    final http.Response response;
    try {
      final streamedResponse = await _client.send(request);
      response = await http.Response.fromStream(streamedResponse);
    } catch (e) {
      throw ApiError("Service unavailable.", 500);
    }

    if (response.statusCode >= 401 && response.statusCode <= 499) {
      _handleSessionExpiry();
      return {};
    }
    final Map<String, dynamic> jsonResp;
    try {
      jsonResp = json.decode(response.body);
    } catch (e) {
      throw ApiError("Something went wrong! Try again.", response.statusCode);
    }
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return jsonResp;
    }

    throw ApiError(
      jsonResp.containsKey("message")
          ? jsonResp["message"]
          : "Something went wrong! Try again.",
      response.statusCode,
    );
  }

  void configureAuth(String refreshToken, String accessToken) {
    _refreshToken = refreshToken;
    _accessToken = accessToken;
    _startTokenRefreshTimer();
  }

  void registerSessionExpiryCallback(Function() func) {
    _sessionExpiryCallback = func;
  }

  void resetAuth() {
    _stopTokenRefreshTimer();
    _refreshToken = null;
    _accessToken = null;
  }

  void _startTokenRefreshTimer() {
    _timer = Timer.periodic(const Duration(minutes: 8), (timer) async {
      await _obtainAccessToken();
    });
  }

  void _stopTokenRefreshTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _handleSessionExpiry() {
    _stopTokenRefreshTimer();
    _refreshToken = null;
    _accessToken = null;
    if (_sessionExpiryCallback != null) _sessionExpiryCallback!();
  }

  Future<void> _obtainAccessToken() async {
    final requestBody = FetchAccessTokenRequestBuilder(
      refreshToken: _refreshToken!,
    ).toRequestBody();
    final request = configureRequest(
      PasswordlyEndPoint.fetchAccessToken,
      body: requestBody,
      authNeeded: false,
    );

    final resp = FetchAccessTokenResponse.fromJson(await send(request));

    _accessToken = resp.accessToken;
  }
}
