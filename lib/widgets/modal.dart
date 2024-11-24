import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:repo/core/data/models/models.dart';
import 'package:repo/core/data/repositories/task_repository_impl.dart';
import 'package:repo/core/data/repositories/user_repository_impl.dart';
import 'package:task_manager/features/home/bloc/home_bloc.dart';
import 'package:task_manager/features/task/bloc/task_bloc.dart';
import 'package:task_manager/src/di/locator.dart';

void showEditModal(BuildContext context, Task task, String userId) {
  final taskBloc = locator.get<TaskRepositoryImpl>();
  final homeBloc = HomeBloc(
    userRepository: UserRepositoryImpl(),
    taskRepository: taskBloc,
  );

  final TextEditingController nameController =
      TextEditingController(text: task.name);
  final TextEditingController dueTimeController = TextEditingController(
    text: DateFormat.yMd().add_jm().format(task.dueTime),
  );

  String selectedPriority = task.priority;
  String selectedCategory = task.category;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (BuildContext modalContext) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TaskBloc(taskBloc)),
          BlocProvider(create: (context) => homeBloc),
        ],
        child: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is TaskUpdated) {
              context.read<HomeBloc>().add(FetchTasks(userId));
              Navigator.pop(modalContext);
            }
          },
          builder: (context, state) {
            if (state is TaskLoading) {
              context.read<HomeBloc>().add(FetchTasks(userId));
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      decoration: const InputDecoration(labelText: 'Task Name'),
                    ),
                    const SizedBox(height: 16.0),
                    // Category Dropdown
                    CategoryDropdown(
                      selectedCategory: selectedCategory,
                      onChanged: (newCategory) {
                        selectedCategory = newCategory;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Priority Dropdown
                    PriorityDropdown(
                      selectedPriority: selectedPriority,
                      onChanged: (newPriority) {
                        selectedPriority = newPriority;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: dueTimeController,
                      decoration: const InputDecoration(labelText: 'Due Time'),
                      readOnly: true,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: task.dueTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(task.dueTime),
                          );
                          if (selectedTime != null) {
                            final newDueTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            dueTimeController.text =
                                DateFormat.yMd().add_jm().format(newDueTime);
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
                          onPressed: () {
                            final updatedTask = task.copyWith(
                              name: nameController.text,
                              category: selectedCategory,
                              priority: selectedPriority,
                              dueTime: DateFormat.yMd()
                                  .add_jm()
                                  .parse(dueTimeController.text),
                            );

                            context
                                .read<TaskBloc>()
                                .add(UpdateTask(updatedTask));
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

class CategoryDropdown extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  const CategoryDropdown({
    Key? key,
    required this.selectedCategory,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      onChanged: (newValue) {
        setState(() {
          _selectedCategory = newValue!;
        });
        widget.onChanged(_selectedCategory);
      },
      items: ['Personal', 'Work', 'Others']
          .map((category) => DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              ))
          .toList(),
      decoration: const InputDecoration(
        labelText: 'Category',
      ),
    );
  }
}

class PriorityDropdown extends StatefulWidget {
  final String selectedPriority;
  final ValueChanged<String> onChanged;

  const PriorityDropdown({
    Key? key,
    required this.selectedPriority,
    required this.onChanged,
  }) : super(key: key);

  @override
  _PriorityDropdownState createState() => _PriorityDropdownState();
}

class _PriorityDropdownState extends State<PriorityDropdown> {
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.selectedPriority;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedPriority,
      onChanged: (newValue) {
        setState(() {
          _selectedPriority = newValue!;
        });
        widget.onChanged(_selectedPriority);
      },
      items: ['Urgent', 'Important', 'Not Important']
          .map((priority) => DropdownMenuItem<String>(
                value: priority,
                child: Text(priority),
              ))
          .toList(),
      decoration: const InputDecoration(
        labelText: 'Priority',
      ),
    );
  }
}
