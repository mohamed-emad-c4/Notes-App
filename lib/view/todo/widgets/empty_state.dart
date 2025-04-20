import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddTask;
  final Color primaryColor;

  const EmptyState({
    super.key,
    required this.onAddTask,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.task_alt,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          const Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Add a task to get started with your productive day',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onAddTask,
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Task'),
          ),
        ],
      ),
    );
  }
}
