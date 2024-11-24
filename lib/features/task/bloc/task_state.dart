part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

final class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

final class TaskCreated extends TaskState {
  final Task task;

  const TaskCreated(this.task);

  @override
  List<Object?> get props => [task];
}

final class TaskDeleted extends TaskState {
  const TaskDeleted();

  @override
  List<Object?> get props => [];
}

class DeleteTaskSuccess extends TaskState {
  final Task task;

  DeleteTaskSuccess(this.task);
}

class TaskUpdated extends TaskState {
  final Task updatedTask;

  const TaskUpdated(this.updatedTask);

  @override
  List<Object?> get props => [updatedTask];
}

// task_state.dart
final class TaskMarkedAsDone extends TaskState {
  final String taskId;

  const TaskMarkedAsDone(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
