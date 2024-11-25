// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:repo/core/data/models/models.dart' as _i9;
import 'package:task_manager/features/home/home_screen.dart' as _i2;
import 'package:task_manager/features/login/login_screen.dart' as _i3;
import 'package:task_manager/features/sign_up/sign_up_screen.dart' as _i4;
import 'package:task_manager/features/task/edit_task.dart' as _i1;
import 'package:task_manager/features/task/task_creation.dart' as _i5;
import 'package:task_manager/features/welcome/welcome.dart' as _i6;

abstract class $AppRouter extends _i7.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    EditTaskRoute.name: (routeData) {
      final args = routeData.argsAs<EditTaskRouteArgs>();
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.EditTaskPage(
          key: args.key,
          task: args.task,
          userId: args.userId,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.LoginScreen(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.SignUpScreen(),
      );
    },
    TaskCreation.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.TaskCreation(),
      );
    },
    WelcomeRoute.name: (routeData) {
      return _i7.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.WelcomePage(),
      );
    },
  };
}

/// generated route for
/// [_i1.EditTaskPage]
class EditTaskRoute extends _i7.PageRouteInfo<EditTaskRouteArgs> {
  EditTaskRoute({
    _i8.Key? key,
    required _i9.Task task,
    required String userId,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          EditTaskRoute.name,
          args: EditTaskRouteArgs(
            key: key,
            task: task,
            userId: userId,
          ),
          initialChildren: children,
        );

  static const String name = 'EditTaskRoute';

  static const _i7.PageInfo<EditTaskRouteArgs> page =
      _i7.PageInfo<EditTaskRouteArgs>(name);
}

class EditTaskRouteArgs {
  const EditTaskRouteArgs({
    this.key,
    required this.task,
    required this.userId,
  });

  final _i8.Key? key;

  final _i9.Task task;

  final String userId;

  @override
  String toString() {
    return 'EditTaskRouteArgs{key: $key, task: $task, userId: $userId}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i3.LoginScreen]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute({List<_i7.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i4.SignUpScreen]
class SignUpRoute extends _i7.PageRouteInfo<void> {
  const SignUpRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i5.TaskCreation]
class TaskCreation extends _i7.PageRouteInfo<void> {
  const TaskCreation({List<_i7.PageRouteInfo>? children})
      : super(
          TaskCreation.name,
          initialChildren: children,
        );

  static const String name = 'TaskCreation';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}

/// generated route for
/// [_i6.WelcomePage]
class WelcomeRoute extends _i7.PageRouteInfo<void> {
  const WelcomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static const _i7.PageInfo<void> page = _i7.PageInfo<void>(name);
}
