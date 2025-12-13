/// Base exception class for all app exceptions
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Server-side exceptions (API errors, database errors)
final class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode});
}

/// Authentication exceptions
final class AppAuthException extends AppException {
  const AppAuthException(super.message);
}

/// Authorization exceptions (not allowed to perform action)
final class AuthorizationException extends AppException {
  const AuthorizationException(super.message);
}

/// Network exceptions
final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// Cache/local storage exceptions
final class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

/// Not found exceptions
final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}
