import 'package:flutter/material.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/app_strings.dart';
import 'package:taskflow/ui/common/text_styles.dart';

class CategoryFilterChip extends StatelessWidget {
  final TaskCategory? category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryFilterChip({
    super.key,
    this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isSelected
        ? (category?.color ?? kcPrimaryColor)
        : (isDark ? kcDarkGreyColor2 : Colors.grey.shade200);
    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.white : Colors.black87);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white
                    : (category?.color ?? Colors.grey),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              category?.displayName ?? ksFilterAll,
              style: AppTextStyles.body(context).copyWith(
                color: textColor,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
