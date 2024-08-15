part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

final class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({
    required this.email,
    required this.password,
  });
}

final class IsUserLoggedInEvent extends AuthEvent {

  IsUserLoggedInEvent();
}