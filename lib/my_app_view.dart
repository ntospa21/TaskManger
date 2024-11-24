import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/bloc/auth_bloc.dart';
import 'package:task_manager/src/routes/app_router.dart';
import 'package:task_manager/src/routes/app_router.gr.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Navigate only when authentication state changes
        if (state.status == AuthenticationStatus.authenticated) {
          appRouter.replaceAll([const HomeRoute()]);
        } else if (state.status == AuthenticationStatus.unauthenticated) {
          appRouter.replaceAll([const LoginRoute()]);
        }
      },
      child: MaterialApp.router(
        routerDelegate: AutoRouterDelegate(
          appRouter,
          navigatorObservers: () => [AutoRouteObserver()],
        ),
        routeInformationParser: appRouter.defaultRouteParser(),
      ),
    );
  }
}
