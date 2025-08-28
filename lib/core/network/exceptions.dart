class FailException implements Exception {
  final dynamic exception;

  FailException({required this.exception});
}
