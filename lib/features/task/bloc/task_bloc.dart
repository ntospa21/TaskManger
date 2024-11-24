import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:repo/core/domain/repositories/task_repository.dart';
import 'package:repo/core/data/models/models.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc(this.taskRepository) : super(TaskInitial()) {
    on<CreateTask>(_onCreateTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
    on<MarkTaskAsDone>(_onMarkTaskAsDone);
  }

  Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.createTask(event.task);
      emit(TaskCreated(event.task));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.deleteTask(event.task.id);
      emit(DeleteTaskSuccess(event.task));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.updateTask(event.updatedTask);
      emit(TaskUpdated(event.updatedTask));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onMarkTaskAsDone(
      MarkTaskAsDone event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await taskRepository.markTaskAsDone(event.taskId);
      emit(TaskMarkedAsDone(event.taskId)); // Emit the TaskMarkedAsDone state
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
