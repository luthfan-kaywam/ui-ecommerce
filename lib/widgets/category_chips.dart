import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: categories.map((category) {
          final isSelected = selectedCategory.toLowerCase() == category.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF4C53A5),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category),
              selectedColor: const Color(0xFF4C53A5),
              backgroundColor: Colors.white,
              elevation: isSelected ? 3 : 1,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF4C53A5)
                      : Colors.grey.shade300,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
