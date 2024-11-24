import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:repo/core/data/models/models.dart';
import 'package:repo/core/data/repositories/task_repository_impl.dart';
import 'package:task_manager/features/task/bloc/task_bloc.dart';
import 'package:task_manager/src/di/locator.dart';
import 'package:task_manager/utils/local_data.dart';
import 'package:task_manager/widgets/modal.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  final String userId;

  const EditTaskPage({
    Key? key,
    required this.task,
    required this.userId,
  }) : super(key: key);

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController nameController;
  late TextEditingController dueTimeController;
  late String selectedPriority;
  late String selectedCategory;
  final LocalTaskStorage _localTaskStorage = LocalTaskStorage();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.task.name);
    dueTimeController = TextEditingController(
      text: DateFormat.yMd().add_jm().format(widget.task.dueTime),
    );
    selectedPriority = widget.task.priority;
    selectedCategory = widget.task.category;
  }

  @override
  void dispose() {
    nameController.dispose();
    dueTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(locator.get<TaskRepositoryImpl>()),
      child: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskUpdated) {
            Navigator.pop(context); // Close page on successful update
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Task'),
            ),
            body: state is TaskLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Edit Task',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(labelText: 'Task Name'),
                          ),
                          const SizedBox(height: 16.0),
                          // Category Dropdown
                          CategoryDropdown(
                            selectedCategory: selectedCategory,
                            onChanged: (newCategory) {
                              setState(() {
                                selectedCategory = newCategory;
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          // Priority Dropdown
                          PriorityDropdown(
                            selectedPriority: selectedPriority,
                            onChanged: (newPriority) {
                              setState(() {
                                selectedPriority = newPriority;
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            controller: dueTimeController,
                            decoration:
                                const InputDecoration(labelText: 'Due Time'),
                            readOnly: true,
                            onTap: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: widget.task.dueTime,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                final selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      widget.task.dueTime),
                                );
                                if (selectedTime != null) {
                                  final newDueTime = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  );
                                  dueTimeController.text = DateFormat.yMd()
                                      .add_jm()
                                      .format(newDueTime);
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final updatedTask = widget.task.copyWith(
                                    name: nameController.text,
                                    category: selectedCategory,
                                    priority: selectedPriority,
                                    dueTime: DateFormat.yMd()
                                        .add_jm()
                                        .parse(dueTimeController.text),
                                  );

                                  // Save to local storage
                                  await _localTaskStorage
                                      .addEditToSyncQueue(updatedTask);

                                  // Check connectivity
                                  final connectivityResult =
                                      await Connectivity().checkConnectivity();

                                  if (connectivityResult ==
                                      ConnectivityResult.none) {
                                    // Offline: Show a message and go back
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Task saved locally. It will sync when online.'),
                                      ),
                                    );
                                    Navigator.pop(
                                        context); // Go back to the main page
                                  } else {
                                    // Online: Dispatch Bloc event for server update
                                    context
                                        .read<TaskBloc>()
                                        .add(UpdateTask(updatedTask));
                                  }
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
