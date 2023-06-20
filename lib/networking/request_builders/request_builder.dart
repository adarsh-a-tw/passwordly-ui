import 'dart:convert';

abstract class RequestBuilder {
  String toRequestBody() {
    return json.encode(toJson());
  }

  Map<String, dynamic> toJson();
}
