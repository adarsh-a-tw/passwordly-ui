class ApiError implements Exception {
  final String message;
  final int statusCode;

  ApiError(this.message, this.statusCode);

  @override
  String toString() {
    return message;
  }
}
