import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/text_styles.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final IconData prefixIcon;
  final double borderRadius;
  final Color borderColor;

  const SearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.prefixIcon = Icons.search_rounded,
    this.borderRadius = 26.0,
    this.borderColor = kcMediumGrey,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.body(
          context,
        ).copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.body(context).copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: kcMediumGrey,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: isDarkMode ? Colors.white70 : kcMediumGrey,
          ),
          filled: true,
          fillColor: isDarkMode ? kcDarkGreyColor2 : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: isDarkMode
                  ? Colors.transparent
                  : Colors.grey.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: kcPrimaryColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
