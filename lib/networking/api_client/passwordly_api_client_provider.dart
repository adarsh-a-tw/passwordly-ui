import 'package:passwordly/networking/api_client/passwordly_api_client.dart';
import 'package:passwordly/utils/environment.dart';

class PasswordlyApiClientProvider {
  static final PasswordlyApiClient client = PasswordlyApiClient(
    Environment().kApiClientUrl,
  );
}
