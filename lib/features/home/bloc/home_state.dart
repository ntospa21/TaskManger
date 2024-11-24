part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final bool isLoading;

  const HomeLoading(this.isLoading);

  @override
  List<Object?> get props => [isLoading];
}

class HomeLoaded extends HomeState {
  final List<Task> tasks;

  const HomeLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class LogoutInProgress extends HomeState {}

class LoggedOut extends HomeState {}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
