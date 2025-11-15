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
    this.borderRadius = 10.0,
    this.borderColor = kcMediumGrey,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.body(context).copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: kcMediumGrey,
        ),
        prefixIcon: Icon(prefixIcon),
        filled: isDarkMode,
        fillColor: isDarkMode ? kcDarkGreyColor2 : null,
        border: isDarkMode
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
              ),
        enabledBorder: isDarkMode
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
              ),
        focusedBorder: isDarkMode
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide.none,
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: kcPrimaryColor),
              ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12.0,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
