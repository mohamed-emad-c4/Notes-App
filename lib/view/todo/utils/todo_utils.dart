import 'package:flutter/material.dart';

class TodoUtils {
  // Define default categories
  static final List<Map<String, dynamic>> defaultCategories = [
    {'name': 'Personal', 'icon': Icons.person, 'color': Colors.blue},
    {'name': 'Work', 'icon': Icons.work, 'color': Colors.orange},
    {'name': 'Shopping', 'icon': Icons.shopping_cart, 'color': Colors.green},
    {'name': 'Health', 'icon': Icons.favorite, 'color': Colors.red},
    {'name': 'Other', 'icon': Icons.category, 'color': Colors.purple},
  ];

  // Get priority color
  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  // Get category details
  static Map<String, dynamic> getCategoryDetails(
      String categoryName, List<Map<String, dynamic>> categories) {
    final category = categories.firstWhere(
      (cat) => cat['name'] == categoryName,
      orElse: () => categories.last,
    );
    return category;
  }

  // Format date for display
  static String formatDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    // Show relative dates for better UX
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
