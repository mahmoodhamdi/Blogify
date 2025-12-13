import 'package:blogify/core/constants/constants.dart';
import 'package:blogify/core/error/exceptions.dart';
import 'package:blogify/core/error/failures.dart';

/// Utility class to map exceptions to failures
class ErrorMapper {
  const ErrorMapper._();

  /// Maps an exception to the appropriate Failure type
  static Failure mapExceptionToFailure(Object exception) {
    if (exception is AppException) {
      return _mapAppException(exception);
    }
    return UnknownFailure(message: exception.toString());
  }

  static Failure _mapAppException(AppException exception) {
    return switch (exception) {
      ServerException e => _mapServerException(e),
      AppAuthException e => AuthFailure(message: e.message),
      AuthorizationException e => AuthorizationFailure(message: e.message),
      NetworkException _ => const NetworkFailure(),
      CacheException e => CacheFailure(message: e.message),
      NotFoundException e => NotFoundFailure(message: e.message),
    };
  }

  static Failure _mapServerException(ServerException exception) {
    final message = exception.message.toLowerCase();

    // Check for specific error patterns
    if (message.contains('not found') || message.contains('does not exist')) {
      return NotFoundFailure(message: exception.message);
    }
    if (message.contains('unauthorized') || message.contains('invalid login')) {
      return AuthFailure(message: exception.message);
    }
    if (message.contains('forbidden') || message.contains('not allowed')) {
      return AuthorizationFailure(message: exception.message);
    }
    if (message.contains('network') || message.contains(Constants.noConnectionErrorMessage.toLowerCase())) {
      return const NetworkFailure();
    }

    return ServerFailure(
      message: exception.message,
      statusCode: exception.statusCode,
    );
  }

  /// Gets a user-friendly error message for display
  static String getUserFriendlyMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure _ => 'Please check your internet connection and try again.',
      ServerFailure _ => 'Something went wrong. Please try again later.',
      AuthFailure f => f.message.isNotEmpty ? f.message : 'Please sign in again.',
      AuthorizationFailure _ => 'You don\'t have permission to do this.',
      ValidationFailure f => f.message,
      CacheFailure _ => 'Unable to load cached data.',
      NotFoundFailure _ => 'The requested item could not be found.',
      UnknownFailure _ => 'An unexpected error occurred.',
    };
  }
}
