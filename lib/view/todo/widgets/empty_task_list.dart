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
    // Get screen dimensions
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    // Determine if we're on a small screen
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isSmallScreen = screenWidth < 360;

    // Calculate relative dimensions
    final double containerSize = isTablet
        ? screenWidth * 0.35 // 35% of screen width
        : (isSmallScreen
            ? screenWidth * 0.38 // 38% of screen width
            : screenWidth * 0.45); // 45% of screen width

    final double iconSize = isTablet
        ? containerSize * 0.45 // 45% of container size
        : containerSize * 0.5; // 50% of container size

    final double imageSize = isTablet
        ? containerSize * 0.7 // 70% of container size
        : containerSize * 0.7; // 70% of container size

    // Calculate text sizes based on screen width
    final double titleSize = isTablet
        ? screenWidth * 0.052 // Increased from 0.045
        : (isSmallScreen
            ? screenWidth * 0.062 // Increased from 0.055
            : screenWidth * 0.068); // Increased from 0.06

    final double descSize = isTablet
        ? screenWidth * 0.032 // Increased from 0.025
        : (isSmallScreen
            ? screenWidth * 0.042 // Increased from 0.035
            : screenWidth * 0.048); // Increased from 0.04

    // Calculate paddings based on screen size
    final double outerPadding = isTablet
        ? screenWidth * 0.05 // 5% of screen width
        : (isSmallScreen
            ? screenWidth * 0.04 // 4% of screen width
            : screenWidth * 0.06); // 6% of screen width

    final double innerPadding = screenWidth * 0.03; // 3% of screen width
    final double smallPadding = screenWidth * 0.02; // 2% of screen width
    final double largePadding = screenWidth * 0.06; // 6% of screen width

    // Calculate button sizing
    final double buttonHPadding = isTablet
        ? screenWidth * 0.05 // 5% of screen width
        : (isSmallScreen
            ? screenWidth * 0.04 // 4% of screen width
            : screenWidth * 0.05); // 5% of screen width

    final double buttonVPadding = isTablet
        ? screenHeight * 0.025 // 2.5% of screen height
        : (isSmallScreen
            ? screenHeight * 0.015 // 1.5% of screen height
            : screenHeight * 0.02); // 2% of screen height

    final double buttonFontSize = isTablet
        ? screenWidth * 0.032 // Increased from 0.025
        : (isSmallScreen
            ? screenWidth * 0.042 // Increased from 0.035
            : screenWidth * 0.048); // Increased from 0.04

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(outerPadding),
          constraints: BoxConstraints(
            maxWidth: isTablet
                ? screenWidth * 0.7 // 70% of screen width
                : screenWidth * 0.9, // 90% of screen width
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
                    width: screenWidth * 0.003, // 0.3% of screen width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withAlpha(20),
                      blurRadius: screenWidth * 0.05, // 5% of screen width
                      spreadRadius: screenWidth * 0.01, // 1% of screen width
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
              SizedBox(height: isSmallScreen ? smallPadding * 2 : largePadding),
              Text(
                isFiltered ? 'No matching tasks found' : 'No tasks yet',
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  letterSpacing: screenWidth * 0.001, // 0.1% of screen width
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? smallPadding : innerPadding),
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
              SizedBox(
                  height: isSmallScreen ? innerPadding * 1.5 : largePadding),
              if (isFiltered && onClearFilter != null)
                // Improved filter button styling
                ElevatedButton.icon(
                  onPressed: onClearFilter,
                  icon: Icon(Icons.filter_alt_off, size: buttonFontSize * 1.2),
                  label: Text(
                    'Clear Filters',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing:
                          screenWidth * 0.001, // 0.1% of screen width
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: buttonHPadding,
                      vertical: buttonVPadding,
                    ),
                    elevation: 6,
                    shadowColor: primaryColor.withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.04), // 4% of screen width
                    ),
                    minimumSize: Size(screenWidth * 0.3,
                        screenHeight * 0.06), // 30% width, 6% height
                  ),
                )
              else if (onAddTask != null)
                // Improved add task button styling
                ElevatedButton.icon(
                  onPressed: onAddTask,
                  icon: Icon(Icons.add, size: buttonFontSize * 1.2),
                  label: Text(
                    'Add New Task',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing:
                          screenWidth * 0.001, // 0.1% of screen width
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: buttonHPadding,
                      vertical: buttonVPadding,
                    ),
                    elevation: 6,
                    shadowColor: primaryColor.withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          screenWidth * 0.04), // 4% of screen width
                    ),
                    minimumSize: Size(screenWidth * 0.3,
                        screenHeight * 0.06), // 30% width, 6% height
                  ),
                ),
              // Additional smaller action button alternative
              if (!isFiltered && onAddTask != null && !isSmallScreen)
                Padding(
                  padding: EdgeInsets.only(top: innerPadding * 1.5),
                  child: TextButton.icon(
                    onPressed: onAddTask,
                    icon: Icon(
                      Icons.lightbulb_outline,
                      color: primaryColor,
                      size: buttonFontSize * 1.1,
                    ),
                    label: Text(
                      'Get started with simple tasks',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: buttonFontSize * 0.9,
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
