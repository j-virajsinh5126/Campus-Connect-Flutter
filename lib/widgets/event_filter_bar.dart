import 'package:flutter/material.dart';

import '../utils/app_constants.dart';

class EventFilterBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const EventFilterBar({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.eventCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = AppConstants.eventCategories[index];
          return ChoiceChip(
            label: Text(category),
            selected: selectedCategory == category,
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}
