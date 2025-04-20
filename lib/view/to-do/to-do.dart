// The file name 'to-do.dart' isn't a lower_case_with_underscores identifier.
// This file will be renamed to 'todo.dart' after fixes are applied.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> tasks = [];
  final String _storageKey = 'todo_tasks';

  late AnimationController _animationController;
  int completedTasks = 0;
  final TextEditingController _newTaskController = TextEditingController();
  bool _isAddingNewTask = false;
  bool _isLoading = true;

  // Task categories
  final List<String> categories = ['Personal', 'Work', 'Shopping', 'Other'];
  String _selectedCategory = 'Personal';

  // Sorting options
  String _sortBy = 'Default'; // Default, Date, Name, Completed
  bool _showCompleted = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadTasks();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _newTaskController.dispose();
    super.dispose();
  }

  // Load tasks from storage
  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_storageKey);

      if (tasksJson != null) {
        final List<dynamic> decodedTasks = jsonDecode(tasksJson);
        setState(() {
          tasks = decodedTasks
              .map<Map<String, dynamic>>(
                  (item) => Map<String, dynamic>.from(item))
              .toList();
        });
      } else {
        // Add default empty task if no tasks exist
        setState(() {
          tasks = [
            {
              'id': UniqueKey().toString(),
              'task': '',
              'isDone': false,
              'category': 'Personal',
              'dueDate': null,
              'createdAt': DateTime.now().toIso8601String(),
              'priority': 'Medium', // Low, Medium, High
            }
          ];
        });
      }
    } catch (e) {
      // Handle error
      debugPrint('Error loading tasks: $e');
    } finally {
      _updateCompletedTasks();
      setState(() => _isLoading = false);
      _animationController.forward();
    }
  }

  // Save tasks to storage
  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = jsonEncode(tasks);
      await prefs.setString(_storageKey, tasksJson);
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }

  // Update completed tasks count
  void _updateCompletedTasks() {
    completedTasks = tasks.where((task) => task['isDone'] == true).length;
  }

  // Add a new task
  void _addNewTask() {
    if (_newTaskController.text.trim().isNotEmpty) {
      setState(() {
        tasks.add({
          'id': UniqueKey().toString(),
          'task': _newTaskController.text.trim(),
          'isDone': false,
          'category': _selectedCategory,
          'dueDate': null,
          'createdAt': DateTime.now().toIso8601String(),
          'priority': 'Medium',
        });
        _newTaskController.clear();
        _isAddingNewTask = false;
        _updateCompletedTasks();
      });

      _saveTasks();
      HapticFeedback.lightImpact();
    }
  }

  // Delete a task
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      _updateCompletedTasks();
    });

    _saveTasks();
    HapticFeedback.mediumImpact();
  }

  // Toggle task completion
  void _toggleTaskCompletion(int index, bool value) {
    setState(() {
      tasks[index]['isDone'] = value;
      _updateCompletedTasks();
    });

    _saveTasks();
    HapticFeedback.selectionClick();
  }

  // Update task (used for editing)
  void _updateTask(int index, Map<String, dynamic> updatedTask) {
    setState(() {
      tasks[index] = updatedTask;
      _updateCompletedTasks();
    });

    _saveTasks();
  }

  // Delete all completed tasks
  void _deleteCompletedTasks() {
    setState(() {
      tasks.removeWhere((task) => task['isDone'] == true);
      _updateCompletedTasks();
    });

    _saveTasks();
    HapticFeedback.mediumImpact();
  }

  // Filter and sort tasks
  List<Map<String, dynamic>> _getFilteredTasks() {
    // First filter by completion status
    var filteredTasks = _showCompleted
        ? List<Map<String, dynamic>>.from(tasks)
        : tasks.where((task) => task['isDone'] == false).toList();

    // Then sort according to criteria
    switch (_sortBy) {
      case 'Name':
        filteredTasks.sort(
            (a, b) => a['task'].toString().compareTo(b['task'].toString()));
        break;
      case 'Date':
        filteredTasks.sort((a, b) {
          final dateA = DateTime.parse(a['createdAt']);
          final dateB = DateTime.parse(b['createdAt']);
          return dateB.compareTo(dateA); // Newest first
        });
        break;
      case 'Completed':
        filteredTasks.sort((a, b) {
          if (a['isDone'] == b['isDone']) return 0;
          return a['isDone'] ? 1 : -1; // Incomplete first
        });
        break;
      case 'Priority':
        filteredTasks.sort((a, b) {
          final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
          return priorityOrder[a['priority']]!
              .compareTo(priorityOrder[b['priority']]!);
        });
        break;
      default: // Default (no sorting)
        break;
    }

    return filteredTasks;
  }

  // Edit task dialog
  Future<void> _showEditTaskDialog(int index) async {
    final task = tasks[index];
    final TextEditingController titleController =
        TextEditingController(text: task['task']);
    String category = task['category'] ?? 'Personal';
    String priority = task['priority'] ?? 'Medium';
    DateTime? dueDate =
        task['dueDate'] != null ? DateTime.parse(task['dueDate']) : null;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    category = value;
                  }
                },
              ),

              const SizedBox(height: 16),

              // Priority dropdown
              DropdownButtonFormField<String>(
                value: priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Medium', 'High'].map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Row(
                      children: [
                        Icon(
                          Icons.flag,
                          color: priority == 'High'
                              ? Colors.red
                              : priority == 'Medium'
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Text(priority),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    priority = value;
                  }
                },
              ),

              const SizedBox(height: 16),

              // Due date selector
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dueDate != null
                          ? 'Due date: ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}'
                          : 'No due date set',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: dueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (selected != null) {
                        dueDate = selected;
                      }
                    },
                    child: Text(dueDate != null ? 'Change' : 'Add'),
                  ),
                  if (dueDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        dueDate = null;
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
            ),
            onPressed: () {
              final updatedTask = Map<String, dynamic>.from(task);
              updatedTask['task'] = titleController.text;
              updatedTask['category'] = category;
              updatedTask['priority'] = priority;
              updatedTask['dueDate'] = dueDate?.toIso8601String();

              _updateTask(index, updatedTask);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Show sort and filter menu
  void _showSortAndFilterMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort & Filter Tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sort by section
                  const Text(
                    'Sort by:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      'Default',
                      'Name',
                      'Date',
                      'Completed',
                      'Priority',
                    ].map((option) {
                      return ChoiceChip(
                        label: Text(option),
                        selected: _sortBy == option,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _sortBy = option;
                            });
                            this.setState(() {});
                          }
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Show/Hide completed tasks
                  SwitchListTile(
                    title: const Text('Show completed tasks'),
                    value: _showCompleted,
                    onChanged: (value) {
                      setState(() {
                        _showCompleted = value;
                      });
                      this.setState(() {});
                    },
                  ),

                  const SizedBox(height: 16),

                  // Clear completed tasks button
                  if (completedTasks > 0)
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteCompletedTasks();
                        },
                        icon: const Icon(Icons.delete_sweep),
                        label: Text('Clear $completedTasks completed tasks'),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final filteredTasks = _getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'To-Do List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          // Task counter
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$completedTasks/${tasks.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // Sort and filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showSortAndFilterMenu,
            tooltip: 'Sort & Filter',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurpleAccent.withAlpha(25),
              Colors.white,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
              )
            : Column(
                children: [
                  // Add task input area
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isAddingNewTask ? 180 : 80,
                    padding: const EdgeInsets.all(16),
                    child: _isAddingNewTask
                        ? Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _newTaskController,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: 'Enter new task',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Category dropdown
                                      Expanded(
                                        child: DropdownButton<String>(
                                          value: _selectedCategory,
                                          isExpanded: true,
                                          hint: const Text('Category'),
                                          underline: Container(
                                            height: 1,
                                            color: Colors.deepPurpleAccent
                                                .withOpacity(0.5),
                                          ),
                                          items:
                                              categories.map((String category) {
                                            return DropdownMenuItem<String>(
                                              value: category,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    category == 'Personal'
                                                        ? Icons.person
                                                        : category == 'Work'
                                                            ? Icons.work
                                                            : category ==
                                                                    'Shopping'
                                                                ? Icons
                                                                    .shopping_cart
                                                                : Icons
                                                                    .category,
                                                    size: 16,
                                                    color:
                                                        Colors.deepPurpleAccent,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(category),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedCategory = value;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // Add button
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.deepPurpleAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: _addNewTask,
                                        child: const Text('Add'),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          setState(() {
                                            _isAddingNewTask = false;
                                            _newTaskController.clear();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isAddingNewTask = true;
                                });
                              },
                              icon: const Icon(Icons.add),
                              label: const Text(
                                'Add New Task',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                  ),

                  // Task list or empty state
                  Expanded(
                    child: tasks.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.task_alt,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No tasks yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Add a task to get started',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : filteredTasks.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.filter_alt,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No matching tasks',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 100),
                                itemCount: filteredTasks.length,
                                itemBuilder: (context, index) {
                                  final task = filteredTasks[index];
                                  final taskIndex = tasks.indexOf(task);

                                  final animation =
                                      Tween<double>(begin: 0.0, end: 1.0)
                                          .animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval(
                                        (index / filteredTasks.length)
                                            .clamp(0.0, 1.0),
                                        ((index + 1) / filteredTasks.length)
                                            .clamp(0.0, 1.0),
                                        curve: Curves.easeInOut,
                                      ),
                                    ),
                                  );

                                  return AnimatedBuilder(
                                    animation: _animationController,
                                    builder: (context, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0.5, 0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Dismissible(
                                      key: Key(
                                          task['id'] ?? UniqueKey().toString()),
                                      background: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade400,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: const Icon(
                                          Icons.delete_sweep,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) =>
                                          _deleteTask(taskIndex),
                                      child: Card(
                                        elevation: 2,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 4,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: task['isDone']
                                                  ? [
                                                      Colors.green
                                                          .withOpacity(0.1),
                                                      Colors.green
                                                          .withOpacity(0.05),
                                                    ]
                                                  : task['priority'] == 'High'
                                                      ? [
                                                          Colors.red
                                                              .withOpacity(0.1),
                                                          Colors.white,
                                                        ]
                                                      : task['priority'] ==
                                                              'Medium'
                                                          ? [
                                                              Colors.orange
                                                                  .withOpacity(
                                                                      0.1),
                                                              Colors.white,
                                                            ]
                                                          : [
                                                              Colors.deepPurple
                                                                  .withOpacity(
                                                                      0.1),
                                                              Colors.white,
                                                            ],
                                            ),
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 4,
                                            ),
                                            leading: Checkbox(
                                              activeColor:
                                                  Colors.deepPurpleAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              value: task['isDone'],
                                              onChanged: (bool? newValue) {
                                                _toggleTaskCompletion(taskIndex,
                                                    newValue ?? false);
                                              },
                                            ),
                                            title: index == 0 &&
                                                    taskIndex == 0 &&
                                                    task['task'].isEmpty
                                                ? TextFormField(
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: 'Enter task',
                                                      hintStyle: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.7),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        tasks[taskIndex]
                                                            ['task'] = value;
                                                      });
                                                      _saveTasks();
                                                    },
                                                    onFieldSubmitted: (value) {
                                                      if (value.isNotEmpty) {
                                                        setState(() {
                                                          tasks.add({
                                                            'id': UniqueKey()
                                                                .toString(),
                                                            'task': '',
                                                            'isDone': false,
                                                            'category':
                                                                'Personal',
                                                            'dueDate': null,
                                                            'createdAt': DateTime
                                                                    .now()
                                                                .toIso8601String(),
                                                            'priority':
                                                                'Medium',
                                                          });
                                                        });
                                                        _saveTasks();
                                                      }
                                                    },
                                                  )
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        task['task'],
                                                        style: TextStyle(
                                                          decoration: task[
                                                                  'isDone']
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : TextDecoration
                                                                  .none,
                                                          color: task['isDone']
                                                              ? Colors.grey
                                                              : isDarkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black87,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              task['priority'] ==
                                                                      'High'
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        children: [
                                                          // Category badge
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 8,
                                                              vertical: 2,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .deepPurpleAccent
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Icon(
                                                                  task['category'] ==
                                                                          'Personal'
                                                                      ? Icons
                                                                          .person
                                                                      : task['category'] ==
                                                                              'Work'
                                                                          ? Icons
                                                                              .work
                                                                          : task['category'] == 'Shopping'
                                                                              ? Icons.shopping_cart
                                                                              : Icons.category,
                                                                  size: 12,
                                                                  color: Colors
                                                                      .deepPurpleAccent,
                                                                ),
                                                                const SizedBox(
                                                                    width: 4),
                                                                Text(
                                                                  task['category'] ??
                                                                      'Other',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .deepPurpleAccent,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          const SizedBox(
                                                              width: 8),

                                                          // Priority indicator
                                                          if (task[
                                                                  'priority'] !=
                                                              null)
                                                            Icon(
                                                              Icons.flag,
                                                              size: 12,
                                                              color: task['priority'] ==
                                                                      'High'
                                                                  ? Colors.red
                                                                  : task['priority'] ==
                                                                          'Medium'
                                                                      ? Colors
                                                                          .orange
                                                                      : Colors
                                                                          .green,
                                                            ),

                                                          // Due date badge
                                                          if (task['dueDate'] !=
                                                              null)
                                                            Expanded(
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 2,
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .blueAccent
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .event,
                                                                      size: 12,
                                                                      color: Colors
                                                                          .blueAccent,
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            4),
                                                                    Text(
                                                                      _formatDate(
                                                                          task[
                                                                              'dueDate']),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .blueAccent,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Edit button
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    color: Colors.blueAccent,
                                                  ),
                                                  onPressed: () =>
                                                      _showEditTaskDialog(
                                                          taskIndex),
                                                  constraints:
                                                      const BoxConstraints(),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                                // Delete button
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.red
                                                        .withOpacity(0.7),
                                                  ),
                                                  onPressed: () =>
                                                      _deleteTask(taskIndex),
                                                  constraints:
                                                      const BoxConstraints(),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                              ],
                                            ),
                                            onTap: () =>
                                                _showEditTaskDialog(taskIndex),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
      ),
      floatingActionButton:
          tasks.isEmpty || (tasks.length == 1 && tasks[0]['task'].isEmpty)
              ? null
              : FloatingActionButton(
                  backgroundColor: Colors.deepPurpleAccent,
                  onPressed: () {
                    setState(() {
                      _isAddingNewTask = true;
                    });
                  },
                  child: const Icon(Icons.add),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Format date for display
  String _formatDate(String? dateString) {
    if (dateString == null) return '';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }
}
