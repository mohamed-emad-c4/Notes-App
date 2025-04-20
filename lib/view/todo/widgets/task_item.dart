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

    // Get screen dimensions for responsive sizing
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Calculate dynamic dimensions
    final bool compactLayout = screenWidth < 360;

    // Calculate dynamic padding and radius values
    final double borderRadius = screenWidth * 0.05; // 5% of screen width
    final double smallBorderRadius = screenWidth * 0.03; // 3% of screen width
    final double iconSize = isTablet
        ? screenWidth * 0.04
        : (compactLayout ? screenWidth * 0.04 : screenWidth * 0.05);

    final double smallIconSize = iconSize * 0.6;
    final double standardPadding = screenWidth * 0.03; // 3% of screen width
    final double smallPadding = screenWidth * 0.02; // 2% of screen width
    final double tinyPadding = screenWidth * 0.01; // 1% of screen width

    // Calculate font sizes
    final double titleSize = isTablet
        ? screenWidth * 0.032
        : (compactLayout ? screenWidth * 0.042 : screenWidth * 0.048);
    final double badgeTextSize =
        isTablet ? screenWidth * 0.02 : screenWidth * 0.034;

    return Dismissible(
      key: Key(task.id),
      background: Container(
        margin: EdgeInsets.symmetric(
          horizontal: cardMargin,
          vertical: screenHeight * 0.005, // 0.5% of screen height
        ),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade200.withOpacity(0.3),
              blurRadius: screenWidth * 0.02, // 2% of screen width
              offset: Offset(0, screenHeight * 0.002), // 0.2% of screen height
            ),
          ],
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: standardPadding * 1.5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? screenWidth * 0.026 : screenWidth * 0.042,
              ),
            ),
            SizedBox(width: smallPadding),
            Icon(
              Icons.delete_sweep,
              color: Colors.white,
              size: iconSize * 1.2,
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
          vertical: screenHeight * 0.005, // 0.5% of screen height
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
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
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: () => onEditTask(index),
            onLongPress: () {
              HapticFeedback.mediumImpact();
              onToggleCompletion(index, !task.isDone);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tinyPadding * 1.5,
                vertical: tinyPadding * 1.5,
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                // Calculate available widths for responsive layout
                final availableWidth = constraints.maxWidth;
                final hasSpace = availableWidth > screenWidth * 0.8;

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
                        margin: EdgeInsets.only(left: smallPadding),
                        child: Checkbox(
                          activeColor: primaryColor,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(smallBorderRadius * 0.5),
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
                        padding: EdgeInsets.symmetric(horizontal: smallPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Task title
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (task.priority == 'High')
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: tinyPadding * 1.5,
                                        top: tinyPadding),
                                    child: Icon(
                                      Icons.priority_high,
                                      size: smallIconSize,
                                      color: Colors.red
                                          .withOpacity(contentOpacity),
                                    ),
                                  ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: tinyPadding),
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
                                        fontSize: titleSize,
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

                            SizedBox(height: smallPadding),

                            // Badges - wrap in a flexible flow widget for small screens
                            Wrap(
                              spacing: tinyPadding * 1.5,
                              runSpacing: tinyPadding * 1.5,
                              children: [
                                // Category badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: smallPadding,
                                    vertical: tinyPadding * 0.8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: categoryColor.withAlpha(30),
                                    borderRadius: BorderRadius.circular(
                                        smallBorderRadius),
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
                                        size: smallIconSize * 0.8,
                                        color: categoryColor
                                            .withOpacity(contentOpacity),
                                      ),
                                      SizedBox(width: tinyPadding),
                                      Text(
                                        task.category,
                                        style: TextStyle(
                                          fontSize: badgeTextSize,
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: smallPadding,
                                    vertical: tinyPadding * 0.8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: priorityColor.withAlpha(30),
                                    borderRadius: BorderRadius.circular(
                                        smallBorderRadius),
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
                                        size: smallIconSize * 0.8,
                                        color: priorityColor
                                            .withOpacity(contentOpacity),
                                      ),
                                      SizedBox(width: tinyPadding),
                                      Text(
                                        task.priority,
                                        style: TextStyle(
                                          fontSize: badgeTextSize,
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
                                    padding: EdgeInsets.symmetric(
                                      horizontal: smallPadding,
                                      vertical: tinyPadding * 0.8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withAlpha(30),
                                      borderRadius: BorderRadius.circular(
                                          smallBorderRadius),
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
                                          size: smallIconSize * 0.8,
                                          color: Colors.blueAccent
                                              .withOpacity(contentOpacity),
                                        ),
                                        SizedBox(width: tinyPadding),
                                        Text(
                                          TodoUtils.formatDate(task.dueDate),
                                          style: TextStyle(
                                            fontSize: badgeTextSize,
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
                              constraints: BoxConstraints(
                                minWidth: iconSize * 2.2,
                                minHeight: iconSize * 2.2,
                              ),
                              padding: EdgeInsets.all(tinyPadding * 1.5),
                              visualDensity: VisualDensity.compact,
                              tooltip: 'Edit task',
                              iconSize: compactLayout
                                  ? smallIconSize * 1.2
                                  : smallIconSize * 1.4,
                            ),
                          ),
                          SizedBox(
                              width: compactLayout
                                  ? tinyPadding * 0.5
                                  : tinyPadding),
                          // Delete button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withAlpha(20),
                            ),
                            margin: EdgeInsets.only(right: smallPadding),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.withAlpha(200),
                              ),
                              onPressed: () => onDeleteTask(index),
                              constraints: BoxConstraints(
                                minWidth: iconSize * 2.2,
                                minHeight: iconSize * 2.2,
                              ),
                              padding: EdgeInsets.all(tinyPadding * 1.5),
                              visualDensity: VisualDensity.compact,
                              tooltip: 'Delete task',
                              iconSize: compactLayout
                                  ? smallIconSize * 1.2
                                  : smallIconSize * 1.4,
                            ),
                          ),
                        ],
                      ),

                    // On small screens, show a single menu button instead
                    if (!hasSpace && !isTablet)
                      Container(
                        margin: EdgeInsets.only(right: smallPadding * 0.5),
                        child: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            size: smallIconSize * 1.4,
                          ),
                          onPressed: () {
                            _showActionMenu(context);
                          },
                          constraints: BoxConstraints(
                            minWidth: iconSize * 2.2,
                            minHeight: iconSize * 2.2,
                          ),
                          padding: EdgeInsets.all(tinyPadding * 1.5),
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double borderRadius = screenWidth * 0.05;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
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
