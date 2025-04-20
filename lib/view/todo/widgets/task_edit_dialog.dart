import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/task_model.dart';
import '../utils/todo_utils.dart';

class TaskEditDialog extends StatefulWidget {
  final TaskModel task;
  final List<Map<String, dynamic>> categories;
  final Color primaryColor;

  const TaskEditDialog({
    super.key,
    required this.task,
    required this.categories,
    required this.primaryColor,
  });

  @override
  State<TaskEditDialog> createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  late TextEditingController _taskController;
  late String _selectedCategory;
  late String _selectedPriority;
  late bool _isDone;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task.task);
    _selectedCategory = widget.task.category;
    _selectedPriority = widget.task.priority;
    _isDone = widget.task.isDone;
    _dueDate = widget.task.dueDate;
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
      HapticFeedback.selectionClick();
    }
  }

  void _clearDueDate() {
    setState(() {
      _dueDate = null;
    });
    HapticFeedback.lightImpact();
  }

  void _saveChanges() {
    if (_taskController.text.trim().isNotEmpty) {
      final updatedTask = widget.task.copyWith(
        task: _taskController.text.trim(),
        isDone: _isDone,
        category: _selectedCategory,
        priority: _selectedPriority,
        dueDate: _dueDate,
      );

      Navigator.of(context).pop(updatedTask);
    } else {
      // Show error for empty task
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task cannot be empty'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return AlertDialog(
      title: Text(
        'Edit Task',
        style: TextStyle(
          color: widget.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: EdgeInsets.all(isTablet ? 24 : 16),
      content: SingleChildScrollView(
        child: SizedBox(
          width: isTablet ? 500 : 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task input
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Task',
                  labelStyle: TextStyle(color: widget.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: widget.primaryColor, width: 2),
                  ),
                ),
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),

              const SizedBox(height: 16),

              // Completion status
              SwitchListTile(
                title: Text(
                  'Mark as completed',
                  style: TextStyle(
                    fontWeight: _isDone ? FontWeight.bold : FontWeight.normal,
                    color: _isDone ? Colors.green : null,
                  ),
                ),
                value: _isDone,
                onChanged: (value) {
                  setState(() {
                    _isDone = value;
                  });
                  HapticFeedback.selectionClick();
                },
                activeColor: Colors.green,
                contentPadding: EdgeInsets.zero,
                dense: !isTablet,
              ),

              const Divider(),

              // Category selection
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: widget.categories.map((category) {
                  final name = category['name'] as String;
                  final icon = category['icon'] as IconData;
                  final color = category['color'] as Color;
                  final isSelected = _selectedCategory == name;

                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: isSelected ? Colors.white : color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = name;
                        });
                        HapticFeedback.selectionClick();
                      }
                    },
                    selectedColor: color,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : color.withAlpha(150),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Priority selection
              const Text(
                'Priority',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Low', 'Medium', 'High'].map((priority) {
                  final isSelected = _selectedPriority == priority;
                  final priorityColor = TodoUtils.getPriorityColor(priority);

                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag,
                          size: 16,
                          color: isSelected ? Colors.white : priorityColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          priority,
                          style: TextStyle(
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedPriority = priority;
                        });
                        HapticFeedback.selectionClick();
                      }
                    },
                    selectedColor: priorityColor,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : priorityColor.withAlpha(150),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Due date selector
              const Text(
                'Due Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.event,
                      color: widget.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _dueDate != null
                            ? TodoUtils.formatDate(_dueDate!)
                            : 'No due date',
                        style: TextStyle(
                          fontSize: 16,
                          color: _dueDate != null ? null : Colors.grey,
                        ),
                      ),
                    ),
                    if (_dueDate != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearDueDate,
                        tooltip: 'Clear due date',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDueDate(context),
                      tooltip: 'Select due date',
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: widget.primaryColor,
          ),
          onPressed: _saveChanges,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
