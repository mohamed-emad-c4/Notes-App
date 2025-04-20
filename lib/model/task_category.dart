import 'package:flutter/material.dart';

class TaskCategory {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  const TaskCategory({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  // Factory for creating from JSON
  factory TaskCategory.fromJson(Map<String, dynamic> json) {
    return TaskCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      color: Color(json['color'] as int),
      icon: IconData(json['iconCodePoint'] as int, fontFamily: 'MaterialIcons'),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'iconCodePoint': icon.codePoint,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
