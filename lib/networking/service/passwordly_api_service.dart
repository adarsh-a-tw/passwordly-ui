import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:passwordly/networking/exceptions/api_error.dart';
import 'package:passwordly/networking/passwordly_end_point.dart';
import 'package:passwordly/networking/request_builders/create_vault_request_builder.dart';
import 'package:passwordly/networking/request_builders/fetch_access_token_builder.dart';
import 'package:passwordly/networking/response_builders/fetch_access_token_response.dart';
import 'package:passwordly/networking/response_builders/fetch_profile_response.dart';
import 'package:passwordly/networking/response_builders/fetch_vault_list_response.dart';
import 'package:passwordly/networking/response_builders/login_response.dart';
import 'package:passwordly/networking/response_builders/vault_response.dart';

import '../request_builders/login_request_builder.dart';

class PasswordlyApiService {
  static const apiHostUrl = "localhost:8080";

  final _client = http.Client();

  String? _refreshToken;
  String? _accessToken;
  Timer? _timer;

  bool _isAuthenticated = false;

  Function()? _sessionExpiryCallback;

  bool get isAuthenticated {
    return _isAuthenticated;
  }

  PasswordlyApiService();

  void registerSessionExpiryCallback(Function() func) {
    _sessionExpiryCallback = func;
  }

  Future<void> login(String username, String password) async {
    final requestBody = LoginRequestBuilder(
      username: username,
      password: password,
    ).toRequestBody();
    final request = _configure(
      PasswordlyEndPoint.login,
      body: requestBody,
      authNeeded: false,
    );

    final resp = LoginResponse.fromJson(await _send(request));

    _refreshToken = resp.refreshToken;
    _accessToken = resp.accessToken;
    _isAuthenticated = true;
    _startTokenRefreshTimer();
  }

  Future<FetchProfileResponse> fetchProfile() async {
    final request = _configure(PasswordlyEndPoint.fetchProfile);
    return FetchProfileResponse.fromJson(await _send(request));
  }

  Future<FetchVaultListResponse> fetchVaults() async {
    final request = _configure(PasswordlyEndPoint.fetchVaults);
    return FetchVaultListResponse.fromJson(await _send(request));
  }

  Future<VaultResponse> fetchVaultDetails(String id) async {
    final request = _configure(
      PasswordlyEndPoint.vaultDetails,
      params: {"id": id},
    );
    return VaultResponse.fromJson(await _send(request));
  }

  Future<void> deleteVault(String id) async {
    final request = _configure(
      PasswordlyEndPoint.deleteVault,
      params: {"id": id},
    );
    await _send(request);
  }

  Future<void> createVault(String name) async {
    final request = _configure(
      PasswordlyEndPoint.createVault,
      body: CreateVaultRequestBuilder(name: name).toRequestBody(),
    );
    await _send(request);
  }

  void logout() {
    _stopTokenRefreshTimer();
    _isAuthenticated = false;
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
    _isAuthenticated = false;
    _refreshToken = null;
    _accessToken = null;
    if (_sessionExpiryCallback != null) _sessionExpiryCallback!();
  }

  Future<void> _obtainAccessToken() async {
    final requestBody = FetchAccessTokenRequestBuilder(
      refreshToken: _refreshToken!,
    ).toRequestBody();
    final request = _configure(
      PasswordlyEndPoint.fetchAccessToken,
      body: requestBody,
      authNeeded: false,
    );

    final resp = FetchAccessTokenResponse.fromJson(await _send(request));

    _accessToken = resp.accessToken;
  }

  http.Request _configure(
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
      Uri.http(
        apiHostUrl,
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

  Future<Map<String, dynamic>> _send(http.Request request) async {
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
}
