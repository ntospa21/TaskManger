import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/features/home/bloc/home_bloc.dart';
import 'package:task_manager/features/task/bloc/task_bloc.dart';
import 'package:repo/core/data/models/task.dart';
import 'package:repo/core/data/repositories/task_repository_impl.dart';
import 'package:repo/core/data/repositories/user_repository_impl.dart';
import 'package:task_manager/src/routes/app_router.gr.dart';
import 'package:task_manager/utils/local_data.dart';
import 'package:task_manager/widgets/modal.dart';
import 'package:task_manager/widgets/task_widget.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;
  late TaskBloc _taskBloc;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  String searchQuery = '';
  String? selectedCategory;
  String? selectedPriority;

  List<Task> tasks = [];
  List<Task> filteredTasks = [];

  final LocalTaskStorage _localTaskStorage =
      LocalTaskStorage(); // LocalTaskStorage instance

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(
      userRepository: UserRepositoryImpl(),
      taskRepository: TaskRepositoryImpl(),
    );
    _taskBloc = TaskBloc(TaskRepositoryImpl());

    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        _syncEditedTasks();
      }
    });

    if (userId != null) {
      // Load tasks from local storage first
      _loadTasksFromLocalStorage();
      // Fetch tasks from Firestore and save them locally
      _homeBloc.add(FetchTasks(userId!));
    }
  }

  // Load tasks from SharedPreferences if no internet
  Future<void> _loadTasksFromLocalStorage() async {
    List<Task> localTasks = await _localTaskStorage.loadTasks();
    setState(() {
      tasks = localTasks;
      filteredTasks = localTasks;
    });
  }

  void _handleOfflineEdit(Task editedTask) {
    setState(() {
      // Update the local task list
      tasks = tasks.map((task) {
        if (task.id == editedTask.id) {
          return editedTask; // Replace the old task with the edited task
        }
        return task;
      }).toList();

      // Also update the filtered tasks list
      filteredTasks = filteredTasks.map((task) {
        if (task.id == editedTask.id) {
          return editedTask; // Replace the old task with the edited task
        }
        return task;
      }).toList();
    });

    _saveTasksToLocalStorage(); // Save the updated tasks list locally
    _localTaskStorage
        .addEditToSyncQueue(editedTask); // Add the edit to the sync queue
  }

  Future<void> _saveTasksToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('tasks', tasksJson);
  }

  Future<void> _syncEditedTasks() async {
    final syncQueue = await _localTaskStorage.loadSyncQueue();
    final editTasks =
        syncQueue.where((task) => task['action'] == 'edit').toList();

    for (var taskData in editTasks) {
      final editedTaskJson = taskData['updatedTask'];
      final editedTask = Task.fromJson(editedTaskJson);

      // Perform the Firestore update (make sure to call your TaskRepository's updateTask method)
      await TaskRepositoryImpl().updateTask(editedTask);

      // After syncing, remove the task from the sync queue
      await _localTaskStorage.removeFromSyncQueue(taskData['taskId']);
    }
  }

  // Add task to sync queue
  Future<void> _addToSyncQueue(String taskId) async {
    await _localTaskStorage.addToSyncQueue(taskId);
  }

  // Inside the HomeScreen
  void _handleEditTask(Task editedTask) {
    _handleOfflineEdit(editedTask); // Update locally and save
    _syncEditedTasks(); // Sync to Firestore when online
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task "${editedTask.name}" updated offline!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => _homeBloc),
        BlocProvider(create: (_) => _taskBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is LoggedOut) {
                context.router.replace(const LoginRoute());
              } else if (state is HomeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is HomeLoaded) {
                setState(() {
                  tasks = state.tasks;
                  _applyFilters();
                });
                // Save tasks to local storage
                _saveTasksToLocalStorage();
              }
            },
          ),
          BlocListener<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is DeleteTaskSuccess) {
                setState(() {
                  tasks.removeWhere((task) => task.id == state.task.id);
                  filteredTasks.removeWhere((task) => task.id == state.task.id);
                });
                _saveTasksToLocalStorage();
              } else if (state is TaskMarkedAsDone) {
                setState(() {
                  print("check");
                  tasks = tasks.map((task) {
                    if (task.id == state.taskId) {
                      return task.copyWith(done: true);
                    }
                    return task;
                  }).toList();
                  _applyFilters();
                });
                _saveTasksToLocalStorage();
              } else if (state is UpdateTask) {
                print("fafa");
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Your Tasks'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _homeBloc.add(const LogOut());
                },
              ),
            ],
          ),
          body: Column(
            children: [
              _buildFilters(),
              Expanded(child: _buildContent()),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.router.push(const TaskCreation()).then((taskCreated) {
                if (taskCreated == true && userId != null) {
                  _homeBloc.add(FetchTasks(userId!));
                }
              });
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        _buildSearchBar(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: _buildCategoryDropdownItems(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      _applyFilters();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedPriority,
                  items: _buildPriorityDropdownItems(),
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value;
                      _applyFilters();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (query) {
          setState(() {
            searchQuery = query;
            _applyFilters();
          });
        },
        decoration: InputDecoration(
          labelText: 'Search Tasks',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                      _applyFilters();
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  void _applyFilters() {
    setState(() {
      filteredTasks = tasks.where((task) {
        final matchesSearch =
            task.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCategory =
            selectedCategory == null || task.category == selectedCategory;
        final matchesPriority =
            selectedPriority == null || task.priority == selectedPriority;
        return matchesSearch && matchesCategory && matchesPriority;
      }).toList();
    });
  }

  List<DropdownMenuItem<String>> _buildCategoryDropdownItems() {
    const categories = ['Personal', 'Work', 'Others'];
    return [
      const DropdownMenuItem(value: null, child: Text('All')),
      ...categories.map((category) {
        return DropdownMenuItem(value: category, child: Text(category));
      })
    ];
  }

  List<DropdownMenuItem<String>> _buildPriorityDropdownItems() {
    const priorities = ['Urgent', 'Important', 'Not Important'];
    return [
      const DropdownMenuItem(value: null, child: Text('All')),
      ...priorities.map((priority) {
        return DropdownMenuItem(value: priority, child: Text(priority));
      })
    ];
  }

  Widget _buildContent() {
    if (filteredTasks.isEmpty) {
      return const Center(child: Text('No tasks found.'));
    }

    return ListView(
      children: filteredTasks.map((task) {
        return TaskWidget(
          task: task,
          onDone: () {
            _taskBloc.taskRepository.markTaskAsDone(task.id);
          },
          onDelete: () {
            if (FirebaseAuth.instance.currentUser == null) {
              setState(() {
                tasks.remove(task);
                filteredTasks.remove(task);
              });
              _addToSyncQueue(task.id);
              _saveTasksToLocalStorage();
            } else {
              _taskBloc.add(DeleteTask(task));
              _homeBloc.add(FetchTasks(userId!));
            }
          },
          onEdit: () {
            context.router.push(WelcomeRoute()).then((_) {
              _localTaskStorage.addEditToSyncQueue(task);
              _homeBloc.add(FetchTasks(userId!));
            });
          },
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _homeBloc.close();
    _taskBloc.close();
    super.dispose();
  }
}
