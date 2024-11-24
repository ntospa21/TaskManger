import '../../data/models/task.dart';

abstract class TaskRepository {
  Future<void> createTask(Task task);

  Future<List<Task>> readAllTasks(String userId);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String taskId);

  Future<void> markTaskAsDone(String taskId);
}
