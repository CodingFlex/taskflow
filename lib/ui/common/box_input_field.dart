import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';


class BoxInputField extends StatelessWidget {
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

  const BoxInputField({
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
    this.borderRadius = 8,
    this.prefixConstraints,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final circularBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    );

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
            fontSize: 16.sp,
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
              fontSize: 16.sp,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: maxLines != null && maxLines! > 1
                  ? 10
                  : (height != null ? height! / 4 : 16),
            ),
            filled: true,
            fillColor: isDark ? kcDarkGrey : Colors.white,
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
            border: isDark
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide.none,
                  )
                : circularBorder.copyWith(
                    borderSide: const BorderSide(color: kcMediumGrey, width: 1),
                  ),
            errorBorder: isDark
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide.none,
                  )
                : circularBorder.copyWith(
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
            focusedBorder: isDark
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide.none,
                  )
                : circularBorder.copyWith(
                    borderSide:
                        const BorderSide(color: kcPrimaryColor, width: 1),
                  ),
            enabledBorder: isDark
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide.none,
                  )
                : circularBorder.copyWith(
                    borderSide: const BorderSide(color: kcMediumGrey, width: 1),
                  ),
            errorText: validator != null ? validator!(controller.text) : null,
          ),
        ),
      ),
    );
  }
}
