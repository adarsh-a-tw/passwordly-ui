import 'package:passwordly/networking/request_method.dart';

enum PasswordlyEndPoint {
  login,
  fetchAccessToken,
  fetchProfile,
  signup,
  createVault,
  fetchVaults,
  vaultDetails,
  deleteVault,
  createSecret;

  String get path {
    switch (this) {
      case login:
        return "/api/v1/users/login";
      case fetchAccessToken:
        return "/api/v1/users/access-token";
      case fetchProfile:
        return "/api/v1/users/me";
      case signup:
        return "/api/v1/users";
      case createVault:
        return "/api/v1/vaults";
      case fetchVaults:
        return "/api/v1/vaults";
      case vaultDetails:
        return "/api/v1/vaults/{:id}";
      case deleteVault:
        return "/api/v1/vaults/{:id}";
      case createSecret:
        return "/api/v1/vaults/{:id}/secrets";
      default:
        return "";
    }
  }

  RequestMethod get method {
    switch (this) {
      case login:
        return RequestMethod.post;
      case fetchAccessToken:
        return RequestMethod.post;
      case fetchProfile:
        return RequestMethod.get;
      case signup:
        return RequestMethod.post;
      case createVault:
        return RequestMethod.post;
      case fetchVaults:
        return RequestMethod.get;
      case vaultDetails:
        return RequestMethod.get;
      case deleteVault:
        return RequestMethod.delete;
      case createSecret:
        return RequestMethod.post;
      default:
        return RequestMethod.get;
    }
  }
}
