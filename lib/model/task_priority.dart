import 'package:flutter/material.dart';

enum TaskPriority {
  low,
  medium,
  high;

  String get name {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.arrow_downward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.arrow_upward;
    }
  }

  static TaskPriority fromString(String value) {
    return TaskPriority.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => TaskPriority.medium,
    );
  }
}
