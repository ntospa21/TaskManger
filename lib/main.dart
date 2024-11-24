import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repo/core/data/repositories/user_repository_impl.dart';
import 'package:repo/core/domain/repositories/user_repository.dart';
import 'package:task_manager/features/auth/bloc/auth_bloc.dart';
import 'package:task_manager/my_app_view.dart';
import 'package:task_manager/src/di/locator.dart';

void main() async {
  setUp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(App(UserRepositoryImpl()));
}

class App extends StatelessWidget {
  final UserRepository userRepository;
  const App(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(userRepository: userRepository),
        ),
        // BlocProvider<ThemeCubit>(
        //   create: (context) => ThemeCubit(), // Initialize ThemeCubit
        // ),
      ],
      child: const MyAppView(),
    );
  }
}
