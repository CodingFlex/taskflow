import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/text_styles.dart';

class CategorySelector extends StatelessWidget {
  final TaskCategory? selectedCategory;
  final Function(TaskCategory) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TaskCategory.values.map((category) {
        final isSelected = selectedCategory == category;
        return GestureDetector(
          onTap: () => onCategorySelected(category),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? category.color
                  : (Theme.of(context).brightness == Brightness.dark
                        ? kcDarkGreyColor2
                        : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? category.color : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.tag,
                  size: 12,
                  color: isSelected ? Colors.white : category.color,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    category.displayName,
                    style: AppTextStyles.body(context).copyWith(
                      fontSize: 14,
                      color: isSelected
                          ? Colors.white
                          : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
