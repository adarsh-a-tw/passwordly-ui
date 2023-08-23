import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/models/version.dart';
import '../networking/exceptions/api_error.dart';

class GithubReleaseTracker {
  final String _githubBaseUrl = "api.github.com";

  final _client = http.Client();

  Future<Version> latestVersion() async {
    final http.Response response;
    try {
      response = await _client.get(
        Uri.https(
          _githubBaseUrl,
          "/repos/adarsh-a-tw/passwordly-ui/releases/latest",
        ),
      );
    } catch (e) {
      throw ApiError("Something went wrong! Try again.", 500);
    }

    if (response.statusCode != 200) {
      throw ApiError("Something went wrong! Try again.", response.statusCode);
    }

    final Map<String, dynamic> jsonResp;
    try {
      jsonResp = json.decode(response.body);
    } catch (e) {
      throw ApiError("Something went wrong! Try again.", response.statusCode);
    }

    final String tagName = jsonResp['tag_name'];

    return Version.fromString(tagName.substring(1));
  }
}
