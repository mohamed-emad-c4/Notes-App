import 'package:flutter/material.dart';

class TaskSort extends StatelessWidget {
  final String currentSortOption;
  final bool isAscending;
  final Function(String) onSortOptionChanged;
  final VoidCallback onSortDirectionChanged;
  final bool isTablet;
  final Color primaryColor;

  const TaskSort({
    super.key,
    required this.currentSortOption,
    required this.isAscending,
    required this.onSortOptionChanged,
    required this.onSortDirectionChanged,
    required this.isTablet,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isTablet ? 12 : 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sort,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Sort By',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 20,
                  color: primaryColor,
                ),
                onPressed: onSortDirectionChanged,
                tooltip: isAscending ? 'Ascending' : 'Descending',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Sort Options
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSortOption(
                'name',
                'Name',
                Icons.sort_by_alpha,
              ),
              _buildSortOption(
                'date_created',
                'Created',
                Icons.access_time,
              ),
              _buildSortOption(
                'due_date',
                'Due Date',
                Icons.event,
              ),
              _buildSortOption(
                'priority',
                'Priority',
                Icons.flag,
              ),
              _buildSortOption(
                'category',
                'Category',
                Icons.category,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(String value, String label, IconData icon) {
    final bool isSelected = currentSortOption == value;

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
              fontSize: isTablet ? 14 : 12,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onSortOptionChanged(value);
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}
