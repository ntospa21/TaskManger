import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String category;
  final DateTime dueDate;
  final String priority;
  final bool done; // New boolean property

  const TaskEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.dueDate,
    required this.priority,
    required this.done, // Initialize the 'done' property
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'category': category,
      'dueDate': Timestamp.fromDate(
          dueDate), // Convert DateTime to Firestore Timestamp
      'priority': priority,
      'done': done, // Add the 'done' property to the Firestore document
    };
  }

  static TaskEntity fromDocument(Map<String, dynamic> doc) {
    return TaskEntity(
      id: doc['id'],
      userId: doc['userId'],
      name: doc['name'],
      category: doc['category'],
      priority: doc['priority'],
      dueDate: (doc['dueDate'] as Timestamp)
          .toDate(), // Convert Timestamp back to DateTime
      done: doc['done'] ??
          false, // Safely retrieve 'done', defaulting to false if not present
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        category,
        dueDate,
        priority,
        done, // Add 'done' to the list of properties for Equatable comparison
      ];
}
