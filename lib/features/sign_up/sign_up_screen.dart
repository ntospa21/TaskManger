import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:repo/core/data/models/user.dart';
import 'package:repo/core/data/repositories/user_repository_impl.dart';
import 'package:task_manager/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:task_manager/src/di/locator.dart';
import 'package:task_manager/widgets/button.dart';
import 'package:task_manager/widgets/textfield.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userRepo = locator.get<UserRepositoryImpl>();

    return BlocProvider(
      create: (context) => SignUpBloc(userRepository: userRepo),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Register",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpInitial) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            } else if (state is SignUpFailure) {
              Navigator.of(context).pop(); // Close loading dialog if shown
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Register failed')),
              );
            } else if (state is SignUpSuccess) {
              Navigator.of(context).pop(); 
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SBTextField(
                        controller: fullNameController,
                        name: "Full Name",
                        inputType: TextInputType.name,
                      ),
                    ),
                    const Gap(12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SBTextField(
                        controller: emailController,
                        name: "Email Address",
                        inputType: TextInputType.emailAddress,
                      ),
                    ),
                    const Gap(12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SBTextField(
                        controller: passwordController,
                        name: "Password",
                        inputType: TextInputType.text,
                        fieldType: TextFieldType.password,
                      ),
                    ),
                    const Gap(12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: SportsButton(
                          height: 70,
                          width: double.infinity,
                          label: "Join now",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final myUser = MyUser.empty.copyWith(
                                email: emailController.text,
                                userId: fullNameController.text,
                              );
                              context.read<SignUpBloc>().add(
                                    SignUpRequired(
                                      user: myUser,
                                      password: passwordController.text,
                                    ),
                                  );
                            }
                          },
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
