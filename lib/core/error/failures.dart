import 'package:equatable/equatable.dart';

/// Base failure class for all failures in the app
sealed class Failure extends Equatable {
  final String message;
  final bool isRetryable;

  const Failure({
    required this.message,
    this.isRetryable = true,
  });

  @override
  List<Object?> get props => [message, isRetryable];
}

/// Network-related failures (no internet connection)
final class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.isRetryable = true,
  });
}

/// Server-side failures (API errors, database errors)
final class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    super.message = 'Something went wrong on our end. Please try again.',
    super.isRetryable = true,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, isRetryable, statusCode];
}

/// Authentication failures (login, signup, session expired)
final class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed. Please try again.',
    super.isRetryable = false,
  });
}

/// Authorization failures (not allowed to perform action)
final class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    super.message = 'You are not authorized to perform this action.',
    super.isRetryable = false,
  });
}

/// Validation failures (invalid input data)
final class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    super.message = 'Invalid input. Please check your data.',
    super.isRetryable = false,
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, isRetryable, fieldErrors];
}

/// Cache/local storage failures
final class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local storage.',
    super.isRetryable = true,
  });
}

/// Resource not found failures
final class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found.',
    super.isRetryable = false,
  });
}

/// Unknown/unexpected failures
final class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.isRetryable = true,
  });
}
