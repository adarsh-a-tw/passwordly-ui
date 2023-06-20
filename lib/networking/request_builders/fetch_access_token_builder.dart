import 'package:passwordly/networking/request_builders/request_builder.dart';

class FetchAccessTokenRequestBuilder extends RequestBuilder {
  final String refreshToken;

  FetchAccessTokenRequestBuilder({required this.refreshToken});

  @override
  Map<String, dynamic> toJson() {
    return {"refresh_token": refreshToken};
  }
}
