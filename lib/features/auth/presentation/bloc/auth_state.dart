part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

final class AuthSuccess extends AuthState {
  final String id;
  AuthSuccess(this.id);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
 
}

class AuthLoading extends AuthState {}
