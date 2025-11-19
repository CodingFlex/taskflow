/// Customizable text input field with support for leading/trailing widgets, validation, password mode, and multi-line input.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/text_styles.dart';

class TaskflowInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final double? height;
  final double? width;
  final Widget? leading;
  final Widget? trailing;
  final bool password;
  final void Function()? trailingTapped;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final int? maxLines;
  final double borderRadius;
  final BoxConstraints? prefixConstraints;

  const TaskflowInputField({
    super.key,
    required this.controller,
    this.placeholder = '',
    this.height,
    this.width,
    this.leading,
    this.trailing,
    this.password = false,
    this.trailingTapped,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.maxLines,
    this.borderRadius = 26,
    this.prefixConstraints,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: ThemeData(primaryColor: kcPrimaryColor),
      child: SizedBox(
        height: height,
        width: width,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: AppTextStyles.body(context).copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
          maxLines: maxLines ?? 1,
          obscureText: password,
          readOnly: !enabled,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppTextStyles.body(context).copyWith(
              color: isDark ? Colors.white70 : kcMediumGrey,
              fontSize: 14.sp,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: maxLines != null && maxLines! > 1
                  ? 10
                  : (height != null ? height! / 4 : 12),
            ),
            filled: true,
            fillColor: isDark ? kcDarkGreyColor2 : Colors.white,
            prefixIcon: leading,
            prefixIconConstraints: prefixConstraints,
            suffixIcon: trailing != null
                ? Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: trailingTapped,
                      behavior: HitTestBehavior.translucent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [trailing!],
                      ),
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: kcPrimaryColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            errorText: validator != null ? validator!(controller.text) : null,
          ),
        ),
      ),
    );
  }
}
