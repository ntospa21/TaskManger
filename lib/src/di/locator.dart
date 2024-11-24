import 'package:get_it/get_it.dart';
import 'package:repo/core/data/repositories/task_repository_impl.dart';
import 'package:repo/core/data/repositories/user_repository_impl.dart';

final locator = GetIt.instance;

void setUp() {
  locator.registerLazySingleton<UserRepositoryImpl>(() => UserRepositoryImpl());
  locator.registerLazySingleton<TaskRepositoryImpl>(() => TaskRepositoryImpl());
}
