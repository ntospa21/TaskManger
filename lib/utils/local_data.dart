import 'dart:convert';
import 'package:repo/core/data/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalTaskStorage {
  static const _tasksKey = 'tasks';
  static const _syncQueueKey = 'syncQueue';

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_tasksKey);
    if (tasksJson != null) {
      final List<dynamic> taskList = jsonDecode(tasksJson);
      return taskList.map((e) => Task.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> saveTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await loadTasks();
    tasks.add(task); // Add the new task to the list
    final tasksJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  Future<void> addEditToSyncQueue(Task editedTask) async {
    final prefs = await SharedPreferences.getInstance();
    final currentQueue = await loadSyncQueue();
    currentQueue.add({
      'taskId': editedTask.id,
      'action': 'edit',
      'updatedTask': editedTask.toJson(),
    });

    await saveSyncQueue(currentQueue);
  }

  Future<void> removeFromSyncQueue(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentQueue = await loadSyncQueue();

    // Remove the task from the queue
    final updatedQueue =
        currentQueue.where((task) => task['taskId'] != taskId).toList();
    await saveSyncQueue(updatedQueue);
  }

  Future<void> addToSyncQueue(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentQueue = await loadSyncQueue();
    currentQueue.add({'taskId': taskId, 'action': 'delete'});

    await saveSyncQueue(currentQueue);
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  Future<List<Map<String, dynamic>>> loadSyncQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = prefs.getString(_syncQueueKey);
    if (queueJson != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(queueJson));
    }
    return [];
  }

  Future<void> saveSyncQueue(List<Map<String, dynamic>> syncQueue) async {
    final prefs = await SharedPreferences.getInstance();
    final queueJson = jsonEncode(syncQueue);
    await prefs.setString(_syncQueueKey, queueJson);
  }

  Future<void> clearSyncQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_syncQueueKey);
  }
}
