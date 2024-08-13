class AppException implements Exception {
  /// The associated error message.
  final String message;

  const AppException(
      [this.message = 'An unexpected error occurred. Please try again.']);

  factory AppException.fromServerException(String message) {
    return AppException(message);
  }
}
