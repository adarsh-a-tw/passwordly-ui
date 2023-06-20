import 'package:passwordly/networking/request_method.dart';

enum PasswordlyEndPoint {
  login,
  fetchAccessToken,
  fetchProfile,
  createVault,
  fetchVaults,
  vaultDetails,
  deleteVault;

  String get path {
    switch (this) {
      case login:
        return "/api/v1/users/login";
      case fetchAccessToken:
        return "/api/v1/users/access-token";
      case fetchProfile:
        return "/api/v1/users/me";
      case createVault:
        return "/api/v1/vaults";
      case fetchVaults:
        return "/api/v1/vaults";
      case vaultDetails:
        return "/api/v1/vaults/{:id}";
      case deleteVault:
        return "/api/v1/vaults/{:id}";
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
      case createVault:
        return RequestMethod.post;
      case fetchVaults:
        return RequestMethod.get;
      case vaultDetails:
        return RequestMethod.get;
      case deleteVault:
        return RequestMethod.delete;
      default:
        return RequestMethod.get;
    }
  }
}
