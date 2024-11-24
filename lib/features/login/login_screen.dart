import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:repo/core/data/repositories/user_repository_impl.dart';
import 'package:task_manager/features/login/bloc/login_bloc.dart';
import 'package:task_manager/src/di/locator.dart';
import 'package:task_manager/src/routes/app_router.gr.dart';
import 'package:task_manager/widgets/button.dart';
import 'package:task_manager/widgets/textfield.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = locator.get<UserRepositoryImpl>();
    return BlocProvider(
      create: (context) => LoginBloc(userRepository: userRepo),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginProcess) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else if (state is LoginSuccess) {
              Navigator.of(context).pop();
            } else if (state is LoginFailure) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Login failed')),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SBTextField(
                      controller: emailController,
                      name: "Email",
                      inputType: TextInputType.emailAddress,
                      fieldType: TextFieldType.simple,
                    ),
                  ),
                  const Gap(50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SBTextField(
                      controller: passwordController,
                      name: "Password",
                      inputType: TextInputType.text,
                      fieldType: TextFieldType.password,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        child: const Text("Forgot your password?"),
                        onTap: () {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24)),
                      child: SportsButton(
                        height: 70,
                        width: double.infinity,
                        label: "Join now",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<LoginBloc>().add(
                                  LoginRequired(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
                                );
                          }
                          print(state);
                        },
                        backgroundColor: Colors.red,
                        textStyle: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  GestureDetector(
                    onTap: () {
                      context.router.push(const SignUpRoute());
                    },
                    child: const Text(
                      "You don't have an account? Register here!",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
