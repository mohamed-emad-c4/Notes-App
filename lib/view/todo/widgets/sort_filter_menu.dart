import 'package:flutter/material.dart';

class SortFilterMenu extends StatelessWidget {
  final String sortBy;
  final bool showCompleted;
  final int completedTasksCount;
  final Color primaryColor;
  final Function(String) onSortChanged;
  final Function(bool) onShowCompletedChanged;
  final VoidCallback onClearCompleted;

  const SortFilterMenu({
    super.key,
    required this.sortBy,
    required this.showCompleted,
    required this.completedTasksCount,
    required this.primaryColor,
    required this.onSortChanged,
    required this.onShowCompletedChanged,
    required this.onClearCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header and close button
          Row(
            children: [
              Icon(
                Icons.filter_list,
                color: primaryColor,
                size: isTablet ? 28 : 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Sort & Filter',
                style: TextStyle(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const Divider(height: 24),

          // Sort options
          Text(
            'Sort by',
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSortChip('Default', 'Default', Icons.sort),
              _buildSortChip('Name', 'Name', Icons.sort_by_alpha),
              _buildSortChip('Date', 'Date', Icons.calendar_today),
              _buildSortChip('Due Date', 'Due Date', Icons.event),
              _buildSortChip(
                  'Completed', 'Completed', Icons.check_circle_outline),
              _buildSortChip('Priority', 'Priority', Icons.flag),
              _buildSortChip('Category', 'Category', Icons.category),
            ],
          ),

          const SizedBox(height: 24),

          // Filter options
          Row(
            children: [
              Text(
                'Show completed tasks',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Switch(
                value: showCompleted,
                onChanged: onShowCompletedChanged,
                activeColor: primaryColor,
              ),
            ],
          ),

          if (completedTasksCount > 0) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onClearCompleted,
              icon: const Icon(Icons.cleaning_services),
              label: Text('Clear all completed ($completedTasksCount)'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSortChip(String value, String label, IconData icon) {
    final bool isSelected = sortBy == value;

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : null,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onSortChanged(value);
        }
      },
      selectedColor: primaryColor,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Colors.transparent : primaryColor.withAlpha(80),
        ),
      ),
    );
  }
}
