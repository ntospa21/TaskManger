import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repo/core/data/models/models.dart';
import 'package:repo/core/domain/repositories/task_repository.dart';
import 'package:repo/core/domain/repositories/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final TaskRepository taskRepository;

  HomeBloc({required this.userRepository, required this.taskRepository})
      : super(HomeInitial()) {
    on<LogOut>(_onLogOut);
    on<FetchTasks>(_onFetchTasks);
  }

  Future<void> _onLogOut(LogOut event, Emitter<HomeState> emit) async {
    emit(LogoutInProgress());
    try {
      await userRepository.logOut();
      emit(LoggedOut());
    } catch (error) {
      emit(HomeError(message: 'Failed to log out. Please try again.'));
    }
  }

  Future<void> _onFetchTasks(FetchTasks event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading(true));
      final tasks = await taskRepository.readAllTasks(event.userId);
      emit(HomeLoaded(tasks));
    } catch (e) {
      emit(HomeError(message: 'Failed to fetch tasks: $e'));
    }
  }
}
