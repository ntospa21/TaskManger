import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final tasksCollection = FirebaseFirestore.instance.collection('tasks');

  @override
  Future<void> createTask(Task task) async {
    try {
      final newDocRef = tasksCollection.doc();
      final taskWithId =
          task.copyWith(id: newDocRef.id); // Set the generated ID

      await newDocRef.set(taskWithId.toEntity().toDocument());
    } catch (e) {
      log('Error creating task: $e');
      rethrow;
    }
  }

  @override
  Future<List<Task>> readAllTasks(String userId) async {
    try {
      final querySnapshot =
          await tasksCollection.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs
          .map((doc) => Task.fromEntity(TaskEntity.fromDocument(doc.data())))
          .toList();
    } catch (e) {
      log('Error reading all tasks: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      await tasksCollection.doc(task.id).update(task.toEntity().toDocument());
    } catch (e) {
      log('Error updating task: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await tasksCollection.doc(taskId).delete();
    } catch (e) {
      log('Error deleting task: $e');
      rethrow;
    }
  }

  @override
  Future<void> markTaskAsDone(String taskId) async {
    try {
      await tasksCollection.doc(taskId).update({'done': true});
    } catch (e) {
      log('Error marking task as done: $e');
      rethrow;
    }
  }
}
