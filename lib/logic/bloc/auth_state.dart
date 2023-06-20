part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class Unauthenticated extends AuthState {}

class LoginError extends AuthState {
  final String message;

  LoginError(this.message);
}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}
