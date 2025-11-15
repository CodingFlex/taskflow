import 'package:flutter/material.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/text_styles.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isSelected
        ? (color ?? kcPrimaryColor)
        : (isDark ? kcDarkGreyColor2 : Colors.grey.shade200);
    final textColor =
        isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87);

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
            if (icon != null) ...[
              Icon(icon, size: 14, color: textColor),
              const SizedBox(width: 6),
            ],
            Text(
              label,
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
