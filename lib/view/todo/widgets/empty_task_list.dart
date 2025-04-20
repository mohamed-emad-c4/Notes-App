import 'package:flutter/material.dart';

class EmptyTaskList extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback? onAddTask;
  final VoidCallback? onClearFilter;
  final bool isTablet;
  final Color primaryColor;

  const EmptyTaskList({
    super.key,
    this.isFiltered = false,
    this.onAddTask,
    this.onClearFilter,
    required this.isTablet,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Adjust sizes based on screen dimensions
    final containerSize = isTablet ? 220.0 : (isSmallScreen ? 140.0 : 180.0);
    final iconSize = isTablet ? 100.0 : (isSmallScreen ? 70.0 : 80.0);
    final imageSize = isTablet ? 150.0 : (isSmallScreen ? 100.0 : 120.0);
    final titleSize = isTablet ? 28.0 : (isSmallScreen ? 20.0 : 24.0);
    final descSize = isTablet ? 18.0 : (isSmallScreen ? 14.0 : 16.0);

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(isTablet ? 32 : (isSmallScreen ? 16 : 24)),
          constraints: BoxConstraints(
            maxWidth: isTablet ? 600 : (isSmallScreen ? 320 : 400),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decorative container with shadow for image/icon
              Container(
                width: containerSize,
                height: containerSize,
                decoration: BoxDecoration(
                  color: primaryColor.withAlpha(isDarkMode ? 30 : 15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withAlpha(isDarkMode ? 70 : 40),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withAlpha(20),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/empty_tasks.png',
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, obj, stack) => Icon(
                      isFiltered ? Icons.filter_alt : Icons.task_alt,
                      size: iconSize,
                      color: primaryColor.withAlpha(150),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 24 : 40),
              Text(
                isFiltered ? 'No matching tasks found' : 'No tasks yet',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              Text(
                isFiltered
                    ? 'Try adjusting your filters to see more tasks'
                    : 'Start creating tasks to organize your day',
                style: TextStyle(
                  fontSize: descSize,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.8),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 24 : 40),
              if (isFiltered && onClearFilter != null)
                // Improved filter button styling
                ElevatedButton.icon(
                  onPressed: onClearFilter,
                  icon: const Icon(Icons.filter_alt_off),
                  label: const Text('Clear Filters'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 32 : (isSmallScreen ? 16 : 24),
                      vertical: isTablet ? 18 : (isSmallScreen ? 12 : 14),
                    ),
                    textStyle: TextStyle(
                      fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    elevation: 6,
                    shadowColor: primaryColor.withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                )
              else if (onAddTask != null)
                // Improved add task button styling
                ElevatedButton.icon(
                  onPressed: onAddTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Task'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 32 : (isSmallScreen ? 16 : 24),
                      vertical: isTablet ? 18 : (isSmallScreen ? 12 : 14),
                    ),
                    textStyle: TextStyle(
                      fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    elevation: 6,
                    shadowColor: primaryColor.withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              // Additional smaller action button alternative
              if (!isFiltered && onAddTask != null && !isSmallScreen)
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: TextButton.icon(
                    onPressed: onAddTask,
                    icon: Icon(Icons.lightbulb_outline, color: primaryColor),
                    label: Text(
                      'Get started with simple tasks',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
