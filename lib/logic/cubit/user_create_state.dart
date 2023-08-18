part of 'user_create_cubit.dart';

@immutable
abstract class UserCreateState {}

class UserCreateInitial extends UserCreateState {}

class UserCreateLoading extends UserCreateState {}

class UserCreateError extends UserCreateState {
  final String message;

  UserCreateError(this.message);
}

class UserCreateSuccess extends UserCreateState {}
