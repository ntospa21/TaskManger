import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:repo/core/data/models/models.dart';
import 'package:repo/core/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/bloc/task_bloc.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepository;
  late TaskBloc taskBloc;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    taskBloc = TaskBloc(mockTaskRepository);
  });

  group('TaskBloc', () {
    final testTask = Task(
      userId: 'gagaga',
      id: '1',
      name: 'Test Task',
      priority: 'Important',
      category: 'Work',
      dueTime: DateTime.now(),
      done: false,
    );

    group('CreateTask', () {
      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskCreated] when task creation is successful',
        build: () {
          // Mock successful task creation
          when(() => mockTaskRepository.createTask(testTask))
              .thenAnswer((_) async {});
          return taskBloc;
        },
        act: (bloc) => bloc.add(CreateTask(testTask)),
        expect: () => [
          TaskLoading(),
          TaskCreated(testTask),
        ],
        verify: (_) {
          verify(() => mockTaskRepository.createTask(testTask)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskError] when task creation fails',
        build: () {
          // Mock failed task creation
          when(() => mockTaskRepository.createTask(testTask))
              .thenThrow(Exception('Failed to create task'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(CreateTask(testTask)),
        expect: () => [
          TaskLoading(),
          TaskError('Exception: Failed to create task'),
        ],
        verify: (_) {
          verify(() => mockTaskRepository.createTask(testTask)).called(1);
        },
      );
    });

    group('DeleteTask', () {
      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, DeleteTaskSuccess] when task deletion is successful',
        build: () {
          // Mock successful task deletion
          when(() => mockTaskRepository.deleteTask(testTask.id))
              .thenAnswer((_) async {});
          return taskBloc;
        },
        act: (bloc) => bloc.add(DeleteTask(testTask)),
        expect: () => [
          TaskLoading(),
          DeleteTaskSuccess(testTask),
        ],
        verify: (_) {
          verify(() => mockTaskRepository.deleteTask(testTask.id)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskError] when task deletion fails',
        build: () {
          // Mock failed task deletion
          when(() => mockTaskRepository.deleteTask(testTask.id))
              .thenThrow(Exception('Failed to delete task'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(DeleteTask(testTask)),
        expect: () => [
          TaskLoading(),
          TaskError('Exception: Failed to delete task'),
        ],
        verify: (_) {
          verify(() => mockTaskRepository.deleteTask(testTask.id)).called(1);
        },
      );
    });

    group('UpdateTask', () {
      final updatedTask = testTask.copyWith(name: 'Updated Task');
      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskUpdated] when task update is successful',
        build: () {
          // Mock successful task update
          when(() => mockTaskRepository.updateTask(updatedTask))
              .thenAnswer((_) async {});
          return taskBloc;
        },
        act: (bloc) => bloc.add(UpdateTask(updatedTask)),
        expect: () => [
          TaskLoading(),
          TaskUpdated(updatedTask),
        ],
        verify: (_) {
          verify(() => mockTaskRepository.updateTask(updatedTask)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskError] when task update fails',
        build: () {
          // Mock failed task update
          when(() => mockTaskRepository.updateTask(updatedTask))
              .thenThrow(Exception('Failed to update task'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(UpdateTask(updatedTask)),
        expect: () => [
          TaskLoading(),
          TaskError('Exception: Failed to update task'),
        ],
        verify: (_) {
          verify(() => mockTaskRepository.updateTask(updatedTask)).called(1);
        },
      );
    });

    group('MarkTaskAsDone', () {
      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskMarkedAsDone] when marking task as done is successful',
        build: () {
          // Mock successful marking of task as done
          when(() => mockTaskRepository.markTaskAsDone(testTask.id))
              .thenAnswer((_) async {});
          return taskBloc;
        },
        act: (bloc) => bloc.add(MarkTaskAsDone(testTask.id)),
        expect: () => [
          TaskLoading(),
          TaskMarkedAsDone(testTask.id),
        ],
        verify: (_) {
          verify(() => mockTaskRepository.markTaskAsDone(testTask.id))
              .called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits [TaskLoading, TaskError] when marking task as done fails',
        build: () {
          // Mock failed marking of task as done
          when(() => mockTaskRepository.markTaskAsDone(testTask.id))
              .thenThrow(Exception('Failed to mark task as done'));
          return taskBloc;
        },
        act: (bloc) => bloc.add(MarkTaskAsDone(testTask.id)),
        expect: () => [
          TaskLoading(),
          TaskError('Exception: Failed to mark task as done'),
        ],
        verify: (_) {
          verify(() => mockTaskRepository.markTaskAsDone(testTask.id))
              .called(1);
        },
      );
    });
  });
}
