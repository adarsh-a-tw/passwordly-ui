import 'package:passwordly/networking/request_builders/request_builder.dart';

class CreateVaultRequestBuilder extends RequestBuilder {
  final String name;

  CreateVaultRequestBuilder({required this.name});

  @override
  Map<String, dynamic> toJson() {
    return {"name": name};
  }
}
