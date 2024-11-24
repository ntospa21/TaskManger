import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repo/core/domain/repositories/user_repository.dart';
import 'package:task_manager/features/login/bloc/login_bloc.dart';

// Create a mock class for UserRepository
class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late LoginBloc loginBloc;

  setUp(() {
    // Initialize mock user repository and bloc before each test
    mockUserRepository = MockUserRepository();
    loginBloc = LoginBloc(userRepository: mockUserRepository);
  });

  tearDown(() {
    // Close the bloc after each test to avoid memory leaks
    loginBloc.close();
  });

  group('LoginBloc', () {
    const email = 'test@example.com';
    const password = 'password123';

    test('initial state is LoginInitial', () {
      // Ensure that the initial state is correct
      expect(loginBloc.state, LoginInitial());
    });

    blocTest<LoginBloc, LoginState>(
      'emits LoginProcess and then LoginSuccess when signIn is successful',
      build: () {
        // Mock successful signIn
        when(() => mockUserRepository.signIn(email, password))
            .thenAnswer((_) async => Future.value());
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginRequired(email: email, password: password)),
      expect: () => [
        LoginProcess(), // Emit loading state first
        LoginSuccess(), // Emit success after signIn
      ],
      verify: (_) {
        // Verify that the signIn method was called once
        verify(() => mockUserRepository.signIn(email, password)).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits LoginProcess and then LoginFailure when signIn fails with FirebaseAuthException',
      build: () {
        // Mock failed signIn with FirebaseAuthException
        when(() => mockUserRepository.signIn(email, password))
            .thenThrow(FirebaseAuthException(code: 'user-not-found'));
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginRequired(email: email, password: password)),
      expect: () => [
        LoginProcess(), // Emit loading state first
        LoginFailure(
            message:
                'user-not-found'), // Emit failure with FirebaseAuthException message
      ],
      verify: (_) {
        // Verify that the signIn method was called once
        verify(() => mockUserRepository.signIn(email, password)).called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits LoginProcess and then LoginFailure when an unknown error occurs',
      build: () {
        // Mock failed signIn with an unknown exception
        when(() => mockUserRepository.signIn(email, password))
            .thenThrow(Exception('Unknown error'));
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginRequired(email: email, password: password)),
      expect: () => [
        LoginProcess(), // Emit loading state first
        const LoginFailure(), // Emit failure with generic message
      ],
      verify: (_) {
        // Verify that the signIn method was called once
        verify(() => mockUserRepository.signIn(email, password)).called(1);
      },
    );
  });
}
