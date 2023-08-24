class Environment {
  static Environment? _instance;

  Environment._();

  factory Environment() {
    _instance ??= Environment._();
    return _instance!;
  }

  String get kApiClientUrl {
    return const String.fromEnvironment("API_URL");
  }

  String get kGithubRepo {
    return const String.fromEnvironment("GH_REPO");
  }
}
