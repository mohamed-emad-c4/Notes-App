import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/task_model.dart';
import 'utils/todo_utils.dart';
import 'widgets/task_item.dart';
import 'widgets/empty_state.dart';
import 'widgets/empty_task_list.dart';
import 'widgets/task_edit_dialog.dart';
import 'widgets/sort_filter_menu.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> with SingleTickerProviderStateMixin {
  List<TaskModel> tasks = [];
  final String _storageKey = 'todo_tasks';

  late AnimationController _animationController;
  int completedTasks = 0;
  final TextEditingController _newTaskController = TextEditingController();
  bool _isAddingNewTask = false;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  // Task categories with improved icons and colors
  final List<Map<String, dynamic>> categories = TodoUtils.defaultCategories;

  String _selectedCategory = 'Personal';
  String _selectedPriority = 'Medium';

  // Sorting options
  String _sortBy = 'Default';
  bool _showCompleted = true;

  // UI Theme settings
  final Color _primaryColor = Colors.deepPurpleAccent;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadTasks();

    // Add listener to scroll to bottom when adding new item
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _newTaskController.dispose();
    _scrollController.dispose();
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
              .map<TaskModel>(
                  (item) => TaskModel.fromMap(Map<String, dynamic>.from(item)))
              .toList();
        });
      } else {
        // Add default empty task if no tasks exist
        setState(() {
          tasks = [
            TaskModel.empty(),
          ];
        });
      }
    } catch (e) {
      // Handle error
      debugPrint('Error loading tasks: $e');
      _showErrorSnackbar('Could not load your tasks. Please try again.');
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
      final tasksJson = jsonEncode(tasks.map((task) => task.toMap()).toList());
      await prefs.setString(_storageKey, tasksJson);
    } catch (e) {
      debugPrint('Error saving tasks: $e');
      _showErrorSnackbar('Could not save your tasks. Please try again.');
    }
  }

  // Show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // Show success snackbar
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Update completed tasks count
  void _updateCompletedTasks() {
    completedTasks = tasks.where((task) => task.isDone).length;
  }

  // Add a new task
  void _addNewTask() {
    if (_newTaskController.text.trim().isNotEmpty) {
      setState(() {
        tasks.add(
          TaskModel(
            id: UniqueKey().toString(),
            task: _newTaskController.text.trim(),
            isDone: false,
            category: _selectedCategory,
            dueDate: null,
            createdAt: DateTime.now(),
            priority: _selectedPriority,
          ),
        );
        _newTaskController.clear();
        _isAddingNewTask = false;
        _updateCompletedTasks();
      });

      _saveTasks();
      HapticFeedback.lightImpact();
      _showSuccessSnackbar('Task added successfully!');

      // Scroll to bottom to show new task
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  // Delete a task
  void _deleteTask(int index) {
    // Store for undo feature
    final deletedTask = tasks[index];

    setState(() {
      tasks.removeAt(index);
      _updateCompletedTasks();
    });

    _saveTasks();
    HapticFeedback.mediumImpact();

    // Show snackbar with undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              tasks.insert(index, deletedTask);
              _updateCompletedTasks();
            });
            _saveTasks();
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Toggle task completion
  void _toggleTaskCompletion(int index, bool value) {
    setState(() {
      tasks[index] = tasks[index].copyWith(isDone: value);
      _updateCompletedTasks();
    });

    _saveTasks();
    HapticFeedback.selectionClick();

    // Show confirmation only when marking as complete
    if (value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task completed! 🎉'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  // Update task (used for editing)
  void _updateTask(int index, TaskModel updatedTask) {
    setState(() {
      tasks[index] = updatedTask;
      _updateCompletedTasks();
    });

    _saveTasks();
    _showSuccessSnackbar('Task updated!');
  }

  // Delete all completed tasks
  void _deleteCompletedTasks() {
    // Save for potential undo
    final deletedTasks = tasks.where((task) => task.isDone).toList();

    setState(() {
      tasks.removeWhere((task) => task.isDone);
      _updateCompletedTasks();
    });

    _saveTasks();
    HapticFeedback.mediumImpact();

    // Show snackbar with undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedTasks.length} completed tasks cleared'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              tasks.addAll(deletedTasks);
              _updateCompletedTasks();
            });
            _saveTasks();
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Filter and sort tasks
  List<TaskModel> _getFilteredTasks() {
    // First filter by completion status
    var filteredTasks = _showCompleted
        ? List<TaskModel>.from(tasks)
        : tasks.where((task) => !task.isDone).toList();

    // Then sort according to criteria
    switch (_sortBy) {
      case 'Name':
        filteredTasks.sort((a, b) => a.task.compareTo(b.task));
        break;
      case 'Date':
        filteredTasks
            .sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Newest first
        break;
      case 'Due Date':
        filteredTasks.sort((a, b) {
          // Null dates come last
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;

          return a.dueDate!.compareTo(b.dueDate!); // Earliest due date first
        });
        break;
      case 'Completed':
        filteredTasks.sort((a, b) {
          if (a.isDone == b.isDone) return 0;
          return a.isDone ? 1 : -1; // Incomplete first
        });
        break;
      case 'Priority':
        filteredTasks.sort((a, b) {
          final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
          return priorityOrder[a.priority]!
              .compareTo(priorityOrder[b.priority]!);
        });
        break;
      case 'Category':
        filteredTasks.sort((a, b) => a.category.compareTo(b.category));
        break;
      default: // Default (no sorting)
        break;
    }

    return filteredTasks;
  }

  // Show edit task dialog
  Future<void> _showEditTaskDialog(int index) async {
    final result = await showDialog<TaskModel?>(
      context: context,
      builder: (context) => TaskEditDialog(
        task: tasks[index],
        categories: categories,
        primaryColor: _primaryColor,
      ),
    );

    if (result != null) {
      _updateTask(index, result);
    }
  }

  // Show sort and filter menu
  void _showSortAndFilterMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SortFilterMenu(
          sortBy: _sortBy,
          showCompleted: _showCompleted,
          completedTasksCount: completedTasks,
          primaryColor: _primaryColor,
          onSortChanged: (value) {
            setState(() {
              _sortBy = value;
            });
          },
          onShowCompletedChanged: (value) {
            setState(() {
              _showCompleted = value;
            });
          },
          onClearCompleted: _deleteCompletedTasks,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final filteredTasks = _getFilteredTasks();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Use relative sizing based on screen dimensions
    final isTablet = screenWidth > 600;
    final isLandscape = screenWidth > screenHeight;
    final isSmallScreen = screenWidth < 360;

    // Calculate dynamic dimensions based on screen size
    final double cardMargin = isTablet
        ? screenWidth * 0.02 // 2% of screen width
        : (isSmallScreen
            ? screenWidth * 0.01
            : screenWidth * 0.015); // 1-1.5% of screen width

    final double taskItemHeight = isTablet
        ? screenHeight * 0.12 // 12% of screen height
        : screenHeight * 0.1; // 10% of screen height

    final double standardPadding = screenWidth * 0.04; // 4% of screen width
    final double smallPadding = screenWidth * 0.02; // 2% of screen width
    final double tinyPadding = screenWidth * 0.01; // 1% of screen width

    final double buttonHeight = isTablet
        ? screenHeight * 0.06 // 6% of screen height
        : screenHeight * 0.05; // 5% of screen height

    final double iconSize = isTablet
        ? screenWidth * 0.04 // 4% of screen width
        : screenWidth * 0.05; // 5% of screen width for better tap targets

    // Calculate font sizes based on screen dimensions
    final double titleFontSize = isTablet
        ? screenWidth * 0.038 // Increased from 0.03 to 0.038
        : screenWidth * 0.048; // Increased from 0.04 to 0.048

    final double bodyFontSize = isTablet
        ? screenWidth * 0.026 // Increased from 0.02 to 0.026
        : screenWidth * 0.036; // Increased from 0.03 to 0.036

    final double smallFontSize = isTablet
        ? screenWidth * 0.022 // Increased from 0.016 to 0.022
        : screenWidth * 0.032; // Increased from 0.025 to 0.032

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.task_alt, color: Colors.white, size: iconSize),
            SizedBox(width: standardPadding * 0.3),
            Text(
              'Tasks',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                fontSize: titleFontSize,
              ),
            ),
          ],
        ),
        backgroundColor: _primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(screenWidth * 0.06), // 6% of screen width
          ),
        ),
        actions: [
          // Task counter with improved contrast
          Padding(
            padding: EdgeInsets.only(right: smallPadding),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: standardPadding * 0.3,
                  vertical: smallPadding * 0.3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(60),
                  borderRadius: BorderRadius.circular(
                      screenWidth * 0.05), // 5% of screen width
                  border:
                      Border.all(color: Colors.white.withAlpha(80), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle,
                        size: iconSize * 0.6, color: Colors.white),
                    SizedBox(width: tinyPadding),
                    Text(
                      '$completedTasks/${tasks.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: smallFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Sort and filter button with improved tap target
          Container(
            margin: EdgeInsets.only(right: smallPadding),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(60),
              borderRadius: BorderRadius.circular(
                  screenWidth * 0.03), // 3% of screen width
            ),
            child: Tooltip(
              message: 'Sort & Filter',
              child: IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: _showSortAndFilterMenu,
                iconSize: iconSize * 0.9,
              ),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _primaryColor.withAlpha(isDarkMode ? 40 : 20),
              isDarkMode ? Colors.black : Colors.white,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: _primaryColor,
                      strokeWidth: screenWidth * 0.005, // 0.5% of screen width
                    ),
                    SizedBox(height: standardPadding),
                    Text(
                      'Loading your tasks...',
                      style: TextStyle(
                        fontSize: bodyFontSize,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // Add task input area with improved animations and styling
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: _isAddingNewTask
                        ? (isTablet
                            ? screenHeight * 0.26 // 26% of screen height
                            : (isSmallScreen
                                ? screenHeight *
                                    0.32 // 32% of screen height for small screens
                                : screenHeight *
                                    0.28)) // 28% of screen height for normal screens
                        : (isTablet
                            ? screenHeight * 0.12 // 12% of screen height
                            : screenHeight * 0.1), // 10% of screen height
                    padding: EdgeInsets.all(isTablet
                        ? standardPadding
                        : (isSmallScreen
                            ? smallPadding
                            : standardPadding * 0.8)),
                    child: _isAddingNewTask
                        ? Card(
                            elevation: 8,
                            shadowColor: _primaryColor.withAlpha(100),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  screenWidth * 0.05), // 5% of screen width
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(isSmallScreen
                                  ? smallPadding
                                  : standardPadding * 0.8),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _newTaskController,
                                    autofocus: true,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: TextStyle(
                                      fontSize: bodyFontSize,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'What needs to be done?',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Colors.grey.withAlpha(180),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.edit_note,
                                        color: _primaryColor.withAlpha(180),
                                        size: iconSize,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: smallPadding * 0.8),
                                  // Use a responsive layout approach for small screens
                                  if (isSmallScreen)
                                    // Stacked layout for small screens
                                    Column(
                                      children: [
                                        // Category dropdown
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              bottom: smallPadding),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: smallPadding),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                screenWidth *
                                                    0.03), // 3% of screen width
                                            border: Border.all(
                                              color: Colors.grey.withAlpha(100),
                                              width: 1,
                                            ),
                                          ),
                                          child: DropdownButton<String>(
                                            value: _selectedCategory,
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                            icon: Icon(Icons.arrow_drop_down,
                                                size: iconSize * 0.7),
                                            items:
                                                categories.map((categoryMap) {
                                              final name =
                                                  categoryMap['name'] as String;
                                              final icon = categoryMap['icon']
                                                  as IconData;
                                              final color =
                                                  categoryMap['color'] as Color;

                                              return DropdownMenuItem<String>(
                                                value: name,
                                                child: Container(
                                                  constraints:
                                                      const BoxConstraints(
                                                    minHeight: 48.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(icon,
                                                          color: color,
                                                          size: iconSize * 0.6),
                                                      SizedBox(
                                                          width: smallPadding),
                                                      Text(name,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  smallFontSize)),
                                                    ],
                                                  ),
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

                                        // Priority and action buttons row
                                        Row(
                                          children: [
                                            // Priority dropdown
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: smallPadding),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(screenWidth *
                                                          0.03), // 3% of screen width
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withAlpha(100),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: DropdownButton<String>(
                                                  value: _selectedPriority,
                                                  isExpanded: true,
                                                  underline: const SizedBox(),
                                                  icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      size: iconSize * 0.7),
                                                  items: [
                                                    'Low',
                                                    'Medium',
                                                    'High'
                                                  ].map((priority) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: priority,
                                                      child: Container(
                                                        constraints:
                                                            const BoxConstraints(
                                                          minHeight: 48.0,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Icon(
                                                              Icons.flag,
                                                              color: TodoUtils
                                                                  .getPriorityColor(
                                                                      priority),
                                                              size: iconSize *
                                                                  0.6,
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    tinyPadding *
                                                                        2),
                                                            // On small screens, show priority text
                                                            Text(
                                                              priority,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    smallFontSize,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            // Always show priority icon
                                                            const SizedBox(
                                                                width: 8),
                                                            Icon(
                                                              priority == 'High'
                                                                  ? Icons
                                                                      .arrow_upward
                                                                  : (priority ==
                                                                          'Medium'
                                                                      ? Icons
                                                                          .remove
                                                                      : Icons
                                                                          .arrow_downward),
                                                              color: TodoUtils
                                                                  .getPriorityColor(
                                                                      priority),
                                                              size: iconSize *
                                                                  0.5,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    if (value != null) {
                                                      setState(() {
                                                        _selectedPriority =
                                                            value;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: smallPadding),

                                            // Action buttons
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: _primaryColor,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(screenWidth *
                                                          0.03), // 3% of screen width
                                                ),
                                                elevation: 2,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      standardPadding * 0.3,
                                                  vertical: smallPadding * 0.8,
                                                ),
                                              ),
                                              onPressed: _addNewTask,
                                              child: Text(
                                                'Add',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: smallFontSize,
                                                ),
                                              ),
                                            ),

                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.grey.shade600,
                                                size: iconSize * 0.7,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isAddingNewTask = false;
                                                  _newTaskController.clear();
                                                });
                                              },
                                              visualDensity:
                                                  VisualDensity.compact,
                                              constraints: BoxConstraints(
                                                minWidth: screenWidth * 0.06,
                                                minHeight: screenWidth * 0.06,
                                              ),
                                              padding: EdgeInsets.all(
                                                  tinyPadding * 2),
                                              tooltip: 'Cancel',
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  else
                                    // Horizontal layout for normal/larger screens
                                    Row(
                                      children: [
                                        // Category dropdown with improved styling
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: smallPadding),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(screenWidth *
                                                      0.03), // 3% of screen width
                                              border: Border.all(
                                                color:
                                                    Colors.grey.withAlpha(100),
                                                width: 1,
                                              ),
                                            ),
                                            child: DropdownButton<String>(
                                              value: _selectedCategory,
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              icon: Icon(Icons.arrow_drop_down,
                                                  size: iconSize * 0.7),
                                              items:
                                                  categories.map((categoryMap) {
                                                final name = categoryMap['name']
                                                    as String;
                                                final icon = categoryMap['icon']
                                                    as IconData;
                                                final color =
                                                    categoryMap['color']
                                                        as Color;

                                                return DropdownMenuItem<String>(
                                                  value: name,
                                                  child: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                      minHeight: 48.0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(icon,
                                                            color: color,
                                                            size:
                                                                iconSize * 0.6),
                                                        SizedBox(
                                                            width:
                                                                smallPadding),
                                                        Text(name,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    smallFontSize)),
                                                      ],
                                                    ),
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
                                        ),

                                        SizedBox(width: standardPadding * 0.3),

                                        // Priority dropdown with improved styling
                                        Expanded(
                                          flex: isTablet ? 2 : 1,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: smallPadding),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(screenWidth *
                                                      0.03), // 3% of screen width
                                              border: Border.all(
                                                color:
                                                    Colors.grey.withAlpha(100),
                                                width: 1,
                                              ),
                                            ),
                                            child: DropdownButton<String>(
                                              value: _selectedPriority,
                                              isExpanded: true,
                                              underline: const SizedBox(),
                                              icon: Icon(Icons.arrow_drop_down,
                                                  size: iconSize * 0.7),
                                              items: ['Low', 'Medium', 'High']
                                                  .map((priority) {
                                                return DropdownMenuItem<String>(
                                                  value: priority,
                                                  child: Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                      minHeight: 48.0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.flag,
                                                          color: TodoUtils
                                                              .getPriorityColor(
                                                                  priority),
                                                          size: iconSize * 0.6,
                                                        ),
                                                        if (isTablet ||
                                                            isLandscape)
                                                          SizedBox(
                                                              width:
                                                                  smallPadding),
                                                        if (isTablet ||
                                                            isLandscape)
                                                          Text(
                                                            priority,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  smallFontSize,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        // Always show priority icon
                                                        const SizedBox(
                                                            width: 8),
                                                        Icon(
                                                          priority == 'High'
                                                              ? Icons
                                                                  .arrow_upward
                                                              : (priority ==
                                                                      'Medium'
                                                                  ? Icons.remove
                                                                  : Icons
                                                                      .arrow_downward),
                                                          color: TodoUtils
                                                              .getPriorityColor(
                                                                  priority),
                                                          size: iconSize * 0.5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _selectedPriority = value;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: standardPadding * 0.3),

                                        // Action buttons with improved styling
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _primaryColor,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(screenWidth *
                                                      0.03), // 3% of screen width
                                            ),
                                            elevation: 2,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: standardPadding * 0.4,
                                              vertical: smallPadding,
                                            ),
                                            minimumSize: Size(screenWidth * 0.1,
                                                buttonHeight),
                                          ),
                                          onPressed: _addNewTask,
                                          child: Text(
                                            'Add',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: smallFontSize,
                                            ),
                                          ),
                                        ),

                                        IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.grey.shade600,
                                            size: iconSize * 0.8,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isAddingNewTask = false;
                                              _newTaskController.clear();
                                            });
                                          },
                                          tooltip: 'Cancel',
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
                                backgroundColor: _primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isTablet
                                      ? standardPadding
                                      : standardPadding * 0.6,
                                  vertical: isTablet
                                      ? smallPadding
                                      : smallPadding * 0.8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      screenWidth * 0.04), // 4% of screen width
                                ),
                                elevation: 4,
                                minimumSize:
                                    Size(screenWidth * 0.2, buttonHeight),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isAddingNewTask = true;
                                });
                              },
                              icon: Icon(Icons.add, size: iconSize * 0.8),
                              label: Text(
                                'Add New Task',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: bodyFontSize,
                                ),
                              ),
                            ),
                          ),
                  ),

                  // Task list or empty state with improved styling
                  Expanded(
                    child: tasks.isEmpty
                        ? EmptyTaskList(
                            onAddTask: () {
                              setState(() {
                                _isAddingNewTask = true;
                              });
                            },
                            onClearFilter: null,
                            isFiltered: false,
                            isTablet: isTablet,
                            primaryColor: _primaryColor,
                          )
                        : filteredTasks.isEmpty
                            ? EmptyTaskList(
                                isFiltered: true,
                                onClearFilter: _showSortAndFilterMenu,
                                onAddTask: null,
                                isTablet: isTablet,
                                primaryColor: _primaryColor,
                              )
                            : _buildTaskList(
                                filteredTasks,
                                isDarkMode,
                                isTablet,
                                cardMargin,
                                taskItemHeight,
                                screenWidth,
                                screenHeight,
                              ),
                  ),
                ],
              ),
      ),
      floatingActionButton: tasks.isEmpty ||
              (tasks.length == 1 && tasks[0].task.isEmpty) ||
              _isAddingNewTask
          ? null
          : FloatingActionButton(
              backgroundColor: _primaryColor,
              onPressed: () {
                setState(() {
                  _isAddingNewTask = true;
                });
              },
              tooltip: 'Add new task',
              elevation: 8,
              child: Icon(Icons.add, size: iconSize * 0.9),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Task list view with improved animations and styling
  Widget _buildTaskList(
    List<TaskModel> filteredTasks,
    bool isDarkMode,
    bool isTablet,
    double cardMargin,
    double taskItemHeight,
    double screenWidth,
    double screenHeight,
  ) {
    // Use a grid layout for tablets in landscape mode
    if (isTablet &&
        MediaQuery.of(context).orientation == Orientation.landscape) {
      return GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(
          top: screenHeight * 0.02, // 2% of screen height
          left: screenWidth * 0.02, // 2% of screen width
          right: screenWidth * 0.02, // 2% of screen width
          bottom: screenHeight * 0.12, // 12% of screen height
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: screenWidth * 0.02, // 2% of screen width
          mainAxisSpacing: screenHeight * 0.02, // 2% of screen height
        ),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          return TaskItem(
            task: filteredTasks[index],
            index: tasks.indexOf(filteredTasks[index]),
            isDarkMode: isDarkMode,
            isTablet: isTablet,
            cardMargin: cardMargin,
            primaryColor: _primaryColor,
            categories: categories,
            onEditTask: _showEditTaskDialog,
            onDeleteTask: _deleteTask,
            onToggleCompletion: _toggleTaskCompletion,
          );
        },
      );
    }

    // Adjust padding for small screens
    final bool isSmallScreen = screenWidth < 360;
    final double horizontalPadding =
        screenWidth * (isSmallScreen ? 0.01 : 0.02); // 1-2% of screen width

    // Use list view for phones and tablets in portrait with improved animations
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
          top: screenHeight * 0.02, // 2% of screen height
          bottom: screenHeight * 0.12, // 12% of screen height
          left: horizontalPadding,
          right: horizontalPadding),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        final taskIndex = tasks.indexOf(task);

        // Animation for each task item with improved timing
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (index / filteredTasks.length).clamp(0.0, 1.0),
              ((index + 1) / filteredTasks.length).clamp(0.0, 1.0),
              curve: Curves.easeOutQuart,
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
                  begin: const Offset(0.3, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.005), // 0.5% of screen height
            child: TaskItem(
              task: task,
              index: taskIndex,
              isDarkMode: isDarkMode,
              isTablet: isTablet,
              cardMargin: cardMargin,
              primaryColor: _primaryColor,
              categories: categories,
              onEditTask: _showEditTaskDialog,
              onDeleteTask: _deleteTask,
              onToggleCompletion: _toggleTaskCompletion,
            ),
          ),
        );
      },
    );
  }
}
