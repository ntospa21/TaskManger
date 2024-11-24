import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:repo/core/data/models/task.dart';
import 'package:repo/core/data/repositories/task_repository_impl.dart';
import 'package:task_manager/features/task/bloc/task_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/src/di/locator.dart';
import 'package:task_manager/widgets/widgets.dart';

@RoutePage()
class TaskCreation extends StatefulWidget {
  const TaskCreation({super.key});

  @override
  State<TaskCreation> createState() => _TaskCreationState();
}

class _TaskCreationState extends State<TaskCreation> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = ['Work', 'Personal', 'Others'];
  final List<String> _priorities = ['Urgent', 'Important', 'Not Important'];
  String? _selectedPriority;
  DateTime? _dueTime;

  @override
  Widget build(BuildContext context) {
    final taskRepo = locator.get<TaskRepositoryImpl>();
    final String userId = FirebaseAuth.instance.currentUser!.uid;

    return BlocProvider(
      create: (context) => TaskBloc(taskRepo),
      child: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Task "${state.task.name}" created successfully!'),
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: const Text('Add Task'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SBTextField(
                        controller: _nameController,
                        name: "Name",
                        inputType: TextInputType.name,
                        fieldType: TextFieldType.simple,
                      ),
                      const Gap(16),

                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _selectedPriority,
                        items: _priorities.map((priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a priority';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Due Time Field
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _dueTime == null
                                  ? 'No Due Date Selected'
                                  : 'Due Date: ${DateFormat.yMMMd().format(_dueTime!)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _dueTime = selectedDate;
                                });
                              }
                            },
                            child: const Text('Select Due Date'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      Center(
                        child: ElevatedButton(
                          onPressed: state is TaskLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_selectedCategory == null ||
                                        _selectedPriority == null ||
                                        _dueTime == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please fill in all fields')),
                                      );
                                      return;
                                    }

                                    final task = Task(
                                      id: '',
                                      name: _nameController.text,
                                      category:
                                          _selectedCategory ?? "Not selected",
                                      dueTime: _dueTime!,
                                      userId: userId,
                                      priority:
                                          _selectedPriority ?? "Not selected",
                                      done: false,
                                    );

                                    context
                                        .read<TaskBloc>()
                                        .add(CreateTask(task));
                                  }
                                },
                          child: state is TaskLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Save Task'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
