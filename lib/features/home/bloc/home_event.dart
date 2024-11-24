part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LogOut extends HomeEvent {
  const LogOut();
}

class FetchTasks extends HomeEvent {
  final String userId;

  const FetchTasks(this.userId);

  @override
  List<Object?> get props => [userId];
}
