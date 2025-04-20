import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/task_model.dart';
import '../utils/todo_utils.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final int index;
  final bool isDarkMode;
  final bool isTablet;
  final double cardMargin;
  final Color primaryColor;
  final List<Map<String, dynamic>> categories;
  final Function(int) onEditTask;
  final Function(int) onDeleteTask;
  final Function(int, bool) onToggleCompletion;

  const TaskItem({
    super.key,
    required this.task,
    required this.index,
    required this.isDarkMode,
    required this.isTablet,
    required this.cardMargin,
    required this.primaryColor,
    required this.categories,
    required this.onEditTask,
    required this.onDeleteTask,
    required this.onToggleCompletion,
  });

  @override
  Widget build(BuildContext context) {
    // Get category details for this task
    final categoryDetails =
        TodoUtils.getCategoryDetails(task.category, categories);
    final categoryIcon = categoryDetails['icon'] as IconData;
    final categoryColor = categoryDetails['color'] as Color;

    // Determine priority color
    final priorityColor = TodoUtils.getPriorityColor(task.priority);

    // Calculate content opacity based on completion status
    final contentOpacity = task.isDone ? 0.7 : 1.0;

    // Determine screen width for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final compactLayout = screenWidth < 360; // Extra small screens

    return Dismissible(
      key: Key(task.id),
      background: Container(
        margin: EdgeInsets.symmetric(
          horizontal: cardMargin,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade200.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 16 : 14,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.delete_sweep,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        // Confirm if task is not empty
        if (task.task.isNotEmpty) {
          // Add haptic feedback
          HapticFeedback.mediumImpact();
          return true;
        }
        return false;
      },
      onDismissed: (direction) => onDeleteTask(index),
      child: Card(
        elevation: 3,
        shadowColor: task.isDone
            ? Colors.green.withAlpha(50)
            : task.priority == 'High'
                ? Colors.red.withAlpha(70)
                : primaryColor.withAlpha(60),
        margin: EdgeInsets.symmetric(
          horizontal: cardMargin,
          vertical: 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: task.isDone
                  ? [
                      Colors.green.withAlpha(30),
                      Theme.of(context).cardColor,
                    ]
                  : task.priority == 'High'
                      ? [
                          Colors.red.withAlpha(40),
                          Theme.of(context).cardColor,
                        ]
                      : task.priority == 'Medium'
                          ? [
                              Colors.orange.withAlpha(40),
                              Theme.of(context).cardColor,
                            ]
                          : [
                              primaryColor.withAlpha(40),
                              Theme.of(context).cardColor,
                            ],
            ),
            border: Border.all(
              color: task.isDone
                  ? Colors.green.withAlpha(80)
                  : priorityColor.withAlpha(80),
              width: 1.5,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onEditTask(index),
            onLongPress: () {
              HapticFeedback.mediumImpact();
              onToggleCompletion(index, !task.isDone);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 6,
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                // Calculate available widths for responsive layout
                final availableWidth = constraints.maxWidth;
                final hasSpace = availableWidth > 320;

                return Row(
                  children: [
                    // Checkbox
                    Transform.scale(
                      scale: isTablet ? 1.2 : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.isDone
                              ? Colors.green.withAlpha(30)
                              : Colors.transparent,
                        ),
                        margin: const EdgeInsets.only(left: 8),
                        child: Checkbox(
                          activeColor: primaryColor,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          side: BorderSide(
                            color: task.isDone
                                ? Colors.green
                                : Theme.of(context).dividerColor,
                            width: 1.5,
                          ),
                          value: task.isDone,
                          onChanged: (bool? newValue) {
                            HapticFeedback.selectionClick();
                            onToggleCompletion(index, newValue ?? false);
                          },
                        ),
                      ),
                    ),

                    // Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Task title
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (task.priority == 'High')
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 6.0, top: 4),
                                    child: Icon(
                                      Icons.priority_high,
                                      size: 16,
                                      color: Colors.red
                                          .withOpacity(contentOpacity),
                                    ),
                                  ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      task.task,
                                      style: TextStyle(
                                        decoration: task.isDone
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: task.isDone
                                            ? Colors.grey
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                        fontSize: isTablet ? 18 : 16,
                                        fontWeight: task.priority == 'High'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Badges - wrap in a flexible flow widget for small screens
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                // Category badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: categoryColor.withAlpha(30),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: categoryColor.withAlpha(80),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        categoryIcon,
                                        size: 12,
                                        color: categoryColor
                                            .withOpacity(contentOpacity),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        task.category,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: categoryColor
                                              .withOpacity(contentOpacity),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Priority indicator
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: priorityColor.withAlpha(30),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: priorityColor.withAlpha(80),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.flag,
                                        size: 12,
                                        color: priorityColor
                                            .withOpacity(contentOpacity),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        task.priority,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: priorityColor
                                              .withOpacity(contentOpacity),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Due date badge
                                if (task.dueDate != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withAlpha(30),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blueAccent.withAlpha(80),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.event,
                                          size: 12,
                                          color: Colors.blueAccent
                                              .withOpacity(contentOpacity),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          TodoUtils.formatDate(task.dueDate),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blueAccent
                                                .withOpacity(contentOpacity),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Action buttons
                    if (hasSpace || isTablet)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withAlpha(20),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: Colors.blueAccent,
                              ),
                              onPressed: () => onEditTask(index),
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8),
                              visualDensity: VisualDensity.compact,
                              tooltip: 'Edit task',
                              iconSize: compactLayout ? 18 : 20,
                            ),
                          ),
                          SizedBox(width: compactLayout ? 2 : 4),
                          // Delete button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withAlpha(20),
                            ),
                            margin: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.withAlpha(200),
                              ),
                              onPressed: () => onDeleteTask(index),
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(8),
                              visualDensity: VisualDensity.compact,
                              tooltip: 'Delete task',
                              iconSize: compactLayout ? 18 : 20,
                            ),
                          ),
                        ],
                      ),

                    // On small screens, show a single menu button instead
                    if (!hasSpace && !isTablet)
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        child: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            _showActionMenu(context);
                          },
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Task actions',
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // Action menu for small screens
  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                title: const Text('Edit Task'),
                onTap: () {
                  Navigator.pop(context);
                  onEditTask(index);
                },
              ),
              ListTile(
                leading: Icon(
                  task.isDone ? Icons.check_box_outline_blank : Icons.check_box,
                  color: task.isDone ? Colors.grey : Colors.green,
                ),
                title: Text(
                    task.isDone ? 'Mark as Incomplete' : 'Mark as Complete'),
                onTap: () {
                  Navigator.pop(context);
                  onToggleCompletion(index, !task.isDone);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Delete Task'),
                onTap: () {
                  Navigator.pop(context);
                  onDeleteTask(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
