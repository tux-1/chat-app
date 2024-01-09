class ExceptionMessage implements Exception {
  final dynamic message;

  ExceptionMessage([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "An error occured.";
    return "$message";
  }
}