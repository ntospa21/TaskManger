part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class CreateTask extends TaskEvent {
  final Task task;

  const CreateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final Task task;
  const DeleteTask(this.task);
}

class UpdateTask extends TaskEvent {
  final Task updatedTask;

  UpdateTask(this.updatedTask);
}

class MarkTaskAsDone extends TaskEvent {
  final String taskId;

  const MarkTaskAsDone(this.taskId);

  @override
  List<Object> get props => [taskId];
}
