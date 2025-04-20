import 'dart:convert';
import 'task_category.dart';
import 'task_priority.dart';

class Task {
  String id;
  String title;
  String? description;
  bool isCompleted;
  DateTime? dueDate;
  DateTime createdAt;
  TaskCategory category;
  TaskPriority priority;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.dueDate,
    required this.createdAt,
    required this.category,
    this.priority = TaskPriority.medium,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      category: TaskCategory.fromJson(jsonDecode(json['category'] as String)),
      priority: TaskPriority.fromString(json['priority'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'category': jsonEncode(category.toJson()),
      'priority': priority.toString().split('.').last,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    DateTime? createdAt,
    TaskCategory? category,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      priority: priority ?? this.priority,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
