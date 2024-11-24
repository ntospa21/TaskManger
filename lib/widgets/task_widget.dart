import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:repo/core/data/models/task.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete; // Ensure this is present
  final VoidCallback onEdit;
  final VoidCallback onDone;

  const TaskWidget({
    super.key,
    required this.task,
    required this.onDelete, // Pass this to the widget
    required this.onEdit,
    required this.onDone,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('dd MMM yyyy').format(widget.task.dueTime);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.task.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Gap(10),
          Text(
            widget.task.category,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Gap(10),
          Text(
            formattedDate, // Use the formatted date here
            style: TextStyle(color: Colors.grey[600]),
          ),
          Gap(8),
          Text(
            widget.task.priority,
            style: TextStyle(color: Colors.grey[600]),
          ),
          Gap(10),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: widget.onEdit,
                tooltip: 'Edit Task',
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: widget.onDelete, // Trigger the callback for delete
                tooltip: 'Delete Task',
              ),
              Spacer(),
              IconButton(
                icon: widget.task.done
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.radio_button_unchecked, color: Colors.grey),
                onPressed: widget.onDone, // Trigger the callback for done
                tooltip: widget.task.done ? 'Task Completed' : 'Mark as Done',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
