enum RequestMethod {
  get,
  post,
  put,
  patch,
  delete;

  String get rawValue {
    switch (this) {
      case get:
        return "GET";
      case post:
        return "POST";
      case put:
        return "PUT";
      case patch:
        return "PATCH";
      case delete:
        return "DELETE";
    }
  }
}
