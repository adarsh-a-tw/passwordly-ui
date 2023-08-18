import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:passwordly/data/repositories/user_repository.dart';

part 'user_create_state.dart';

class UserCreateCubit extends Cubit<UserCreateState> {
  final UserRepository repository;
  UserCreateCubit(this.repository) : super(UserCreateInitial());

  Future<void> createUser(
    String username,
    String email,
    String password,
  ) async {
    emit(UserCreateLoading());
    try {
      await repository.signup(
        username,
        email,
        password,
      );
      emit(UserCreateSuccess());
    } catch (exception) {
      emit(UserCreateError(exception.toString()));
    }
  }

  void resetState() {
    emit(UserCreateInitial());
  }
}
