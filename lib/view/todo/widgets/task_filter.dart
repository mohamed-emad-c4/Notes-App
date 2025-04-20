import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../model/task_priority.dart';
import '../../../model/task_category.dart';
import '../../../model/task.dart';
import '../utils/todo_utils.dart';

class TaskFilter extends StatefulWidget {
  final List<TaskCategory> availableCategories;
  final List<Task> tasks;
  final Set<TaskCategory> selectedCategories;
  final Set<TaskPriority> selectedPriorities;
  final bool showCompleted;
  final bool onlyDueToday;
  final bool onlyOverdue;
  final Color primaryColor;
  final Function(Set<TaskCategory>) onCategoryFilterChanged;
  final Function(Set<TaskPriority>) onPriorityFilterChanged;
  final Function(bool) onShowCompletedChanged;
  final Function(bool) onDueTodayChanged;
  final Function(bool) onOverdueChanged;
  final VoidCallback onClearFilters;
  final Function(List<Task>) onFilterApplied;

  const TaskFilter({
    super.key,
    required this.availableCategories,
    required this.tasks,
    required this.selectedCategories,
    required this.selectedPriorities,
    required this.showCompleted,
    required this.onlyDueToday,
    required this.onlyOverdue,
    required this.primaryColor,
    required this.onCategoryFilterChanged,
    required this.onPriorityFilterChanged,
    required this.onShowCompletedChanged,
    required this.onDueTodayChanged,
    required this.onOverdueChanged,
    required this.onClearFilters,
    required this.onFilterApplied,
  });

  @override
  State<TaskFilter> createState() => _TaskFilterState();
}

class _TaskFilterState extends State<TaskFilter> {
  bool get isTablet => MediaQuery.of(context).size.width > 600;

  void _applyFilters() {
    final filteredTasks = widget.tasks.where((task) {
      // Filter by completion status
      if (!widget.showCompleted && task.isCompleted) {
        return false;
      }

      // Filter by categories if any selected
      if (widget.selectedCategories.isNotEmpty &&
          !widget.selectedCategories.contains(task.category)) {
        return false;
      }

      // Filter by priority if any selected
      if (widget.selectedPriorities.isNotEmpty &&
          !widget.selectedPriorities.contains(task.priority)) {
        return false;
      }

      // Filter by due today
      if (widget.onlyDueToday) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        if (task.dueDate == null) {
          return false;
        }
        final dueDate = DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        );
        if (dueDate != today) {
          return false;
        }
      }

      // Filter by overdue
      if (widget.onlyOverdue) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        if (task.dueDate == null) {
          return false;
        }
        final dueDate = DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        );
        if (dueDate.isAfter(today) || dueDate.isAtSameMomentAs(today)) {
          return false;
        }
      }

      return true;
    }).toList();

    widget.onFilterApplied(filteredTasks);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      margin: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: widget.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Filter Tasks',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: widget.onClearFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear'),
                style: TextButton.styleFrom(
                  foregroundColor: widget.primaryColor,
                ),
              ),
            ],
          ),
          const Divider(),

          // Status filters
          _buildFilterSection(
            'Status',
            [
              SwitchListTile(
                title: const Text('Show Completed Tasks'),
                value: widget.showCompleted,
                onChanged: widget.onShowCompletedChanged,
                dense: !isTablet,
                activeColor: widget.primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                title: const Text('Only Due Today'),
                value: widget.onlyDueToday,
                onChanged: widget.onDueTodayChanged,
                dense: !isTablet,
                activeColor: widget.primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                title: const Text('Only Overdue'),
                value: widget.onlyOverdue,
                onChanged: widget.onOverdueChanged,
                dense: !isTablet,
                activeColor: widget.primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),

          // Priority filters
          _buildFilterSection(
            'Priority',
            [
              Wrap(
                spacing: 8,
                children: TaskPriority.values.map((priority) {
                  final isSelected =
                      widget.selectedPriorities.contains(priority);
                  return FilterChip(
                    label: Text(priority.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      final newSelection =
                          Set<TaskPriority>.from(widget.selectedPriorities);
                      if (selected) {
                        newSelection.add(priority);
                      } else {
                        newSelection.remove(priority);
                      }
                      widget.onPriorityFilterChanged(newSelection);
                      HapticFeedback.selectionClick();
                    },
                    selectedColor: priority.color.withAlpha(80),
                    checkmarkColor: priority.color,
                    labelStyle: TextStyle(
                      color: isSelected ? priority.color : null,
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Category filters
          if (widget.availableCategories.isNotEmpty)
            _buildFilterSection(
              'Categories',
              [
                Wrap(
                  spacing: 8,
                  children: widget.availableCategories.map((category) {
                    final isSelected =
                        widget.selectedCategories.contains(category);
                    return FilterChip(
                      avatar: Icon(
                        category.icon,
                        size: 16,
                        color: isSelected ? category.color : Colors.grey,
                      ),
                      label: Text(category.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        final newSelection =
                            Set<TaskCategory>.from(widget.selectedCategories);
                        if (selected) {
                          newSelection.add(category);
                        } else {
                          newSelection.remove(category);
                        }
                        widget.onCategoryFilterChanged(newSelection);
                        HapticFeedback.selectionClick();
                      },
                      selectedColor: category.color.withAlpha(80),
                      checkmarkColor: category.color,
                      labelStyle: TextStyle(
                        color: isSelected ? category.color : null,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

          // Apply filters button
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 8),
      ],
    );
  }
}
