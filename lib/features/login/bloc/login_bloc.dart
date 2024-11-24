import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:repo/core/domain/repositories/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginInitial()) {
    // Handle the LoginRequired event
    on<LoginRequired>((event, emit) async {
      emit(LoginProcess()); // Emit a loading state first

      try {
        await _userRepository.signIn(event.email, event.password);
        emit(LoginSuccess());
      } on FirebaseAuthException catch (e) {
        emit(LoginFailure(message: e.code));
      } catch (e) {
        emit(const LoginFailure());
      }
    });

    // Handle the LogOut event
    on<LogOut>((event, emit) async {
      // Add logout logic here if needed
      emit(LoginInitial()); // Reset state to initial after logout
    });
  }
}
