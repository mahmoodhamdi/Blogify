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
    required this.password,});
}