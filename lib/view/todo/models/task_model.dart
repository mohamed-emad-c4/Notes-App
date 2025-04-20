import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String task;
  final bool isDone;
  final String category;
  final DateTime? dueDate;
  final DateTime createdAt;
  final String priority;

  TaskModel({
    required this.id,
    required this.task,
    required this.isDone,
    required this.category,
    this.dueDate,
    required this.createdAt,
    required this.priority,
  });

  // Create a copy of this task with different values
  TaskModel copyWith({
    String? id,
    String? task,
    bool? isDone,
    String? category,
    DateTime? dueDate,
    DateTime? createdAt,
    String? priority,
  }) {
    return TaskModel(
      id: id ?? this.id,
      task: task ?? this.task,
      isDone: isDone ?? this.isDone,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
    );
  }

  // Factory constructor to create a TaskModel from a Map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? UniqueKey().toString(),
      task: map['task'] ?? '',
      isDone: map['isDone'] ?? false,
      category: map['category'] ?? 'Personal',
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      priority: map['priority'] ?? 'Medium',
    );
  }

  // Convert a TaskModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'isDone': isDone,
      'category': category,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'priority': priority,
    };
  }

  // Create an empty task
  factory TaskModel.empty() {
    return TaskModel(
      id: UniqueKey().toString(),
      task: '',
      isDone: false,
      category: 'Personal',
      dueDate: null,
      createdAt: DateTime.now(),
      priority: 'Medium',
    );
  }
}
