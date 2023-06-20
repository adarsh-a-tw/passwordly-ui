import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:passwordly/data/models/user.dart';
import 'package:passwordly/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(Unauthenticated()) {
    on<AuthEvent>(_manageEvent);
  }

  void _manageEvent(event, emit) async {
    if (event is LoginEvent) {
      emit(AuthLoading());
      try {
        await authRepository.login(event.username, event.password);
        final user = await authRepository.fetchProfile();
        emit(Authenticated(user));
      } catch (exception) {
        emit(LoginError(exception.toString()));
      }
    } else if (event is LogoutEvent || event is ClearLoginErrorEvent) {
      authRepository.logout();
      emit(Unauthenticated());
    }
  }
}
