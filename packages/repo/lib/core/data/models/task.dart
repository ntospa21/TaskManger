import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';

class Task extends Equatable {
  final String name;
  final String category;
  final DateTime dueTime;
  final String id;
  final String userId;
  final String priority;
  final bool done;

  const Task({
    required this.name,
    required this.category,
    required this.dueTime,
    required this.id,
    required this.userId,
    required this.priority,
    required this.done,
  });

  static var empty = Task(
    name: '',
    category: '',
    userId: '',
    id: '',
    priority: '',
    done: false,
    dueTime: DateTime(1970, 1, 1), // Unix epoch time as default
  );

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        name: json['name'],
        category: json['category'],
        priority: json['priority'],
        dueTime: DateTime.parse(json['dueDate']),
        done: json['done'],
        userId: json['userId']);
  }

  // toJson: Serialize the Task object to a map (e.g., to save in SharedPreferences or to send to an API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'priority': priority,
      'dueTime': dueTime.toIso8601String(),
      'done': done,
    };
  }

  Task copyWith({
    String? name,
    String? category,
    DateTime? dueTime,
    String? id,
    String? userId,
    String? priority,
    bool? done,
  }) {
    return Task(
      name: name ?? this.name,
      category: category ?? this.category,
      dueTime: dueTime ?? this.dueTime,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      priority: priority ?? this.priority,
      done: done ?? this.done,
    );
  }

  /// Convert a Task to TaskEntity
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      name: name,
      category: category,
      dueDate: dueTime,
      userId: userId,
      priority: priority,
      done: done,
    );
  }

  /// Create a Task from TaskEntity
  static Task fromEntity(TaskEntity entity) {
    return Task(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      dueTime: entity.dueDate,
      userId: entity.userId,
      priority: entity.priority,
      done: entity.done,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        dueTime,
        userId,
        priority,
        done,
      ];
}
