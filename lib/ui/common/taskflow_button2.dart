import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:taskflow/ui/common/app_colors.dart';
import 'package:taskflow/ui/common/text_styles.dart';

enum TaskflowButton2Type { primary, secondary, danger }

enum TaskflowButton2State { enabled, disabled, loading }

class TaskflowButton2 extends StatefulWidget {
  final String title;
  final TaskflowButton2Type type;
  final TaskflowButton2State state;
  final void Function()? onTap;
  final Widget? leading;
  final double width;
  final double height;
  final Color? color;
  final TextStyle? textStyle;
  final Color? outlineColor; // Optional override for outline color
  final Color? textColor; // Optional override for text color
  final double borderRadius; // Border radius
  final bool isDelete; // Deprecated: use type == danger
  final bool noBorder; // Remove border
  final bool noShadow; // Remove shadow

  const TaskflowButton2({
    super.key,
    required this.title,
    this.type = TaskflowButton2Type.primary,
    this.state = TaskflowButton2State.enabled,
    this.onTap,
    this.leading,
    this.width = double.infinity,
    this.height = 45.0,
    this.textStyle,
    this.color = Colors.transparent, // Default to transparent
    this.outlineColor, // Fallbacks handled below
    this.textColor, // Fallbacks handled below
    this.borderRadius = 16.0,
    this.isDelete = false,
    this.noBorder = false,
    this.noShadow = false,
  });

  @override
  State<TaskflowButton2> createState() => _TaskflowButton2State();
}

class _TaskflowButton2State extends State<TaskflowButton2> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Define delete styling
    const Color deleteOutlineColor = Colors.red;
    const Color deleteTextColor = Colors.red;

    // Determine base color from type if color not provided
    final Color baseColor =
        widget.color ??
        () {
          switch (widget.isDelete ? TaskflowButton2Type.danger : widget.type) {
            case TaskflowButton2Type.primary:
              return kcPrimaryColor;
            case TaskflowButton2Type.secondary:
              return kcDarkGreyColor;
            case TaskflowButton2Type.danger:
              return deleteOutlineColor;
          }
        }();

    final bool isDisabled = widget.state == TaskflowButton2State.disabled;
    final bool isLoading = widget.state == TaskflowButton2State.loading;
    final bool isEnabled = widget.state == TaskflowButton2State.enabled;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        onTapDown: isEnabled
            ? (_) {
                setState(() {
                  _isPressed = true;
                });
              }
            : null,
        onTapUp: isEnabled
            ? (_) {
                setState(() {
                  _isPressed = false;
                });
              }
            : null,
        onTapCancel: isEnabled
            ? () {
                setState(() {
                  _isPressed = false;
                });
              }
            : null,
        onTap: isEnabled && widget.onTap != null
            ? () {
                widget.onTap!();
              }
            : null,
        splashColor: kcPrimaryColor.withOpacity(0.1),
        highlightColor: kcPrimaryColor.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()
            ..scale(_isPressed ? 0.96 : 1.0)
            ..translate(0.0, _isPressed ? 2.0 : 0.0),
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                widget.color ?? Colors.white, // Keep existing default behavior
            borderRadius: BorderRadius.circular(
              widget.borderRadius,
            ), // Use the provided border radius
            border: widget.noBorder
                ? null // No border if noBorder is true
                : (widget.outlineColor == null && widget.textColor == null)
                ? null // No border if both are null
                : Border.all(
                    color: widget.isDelete
                        ? deleteOutlineColor
                        : isDisabled
                        ? kcMediumGrey
                        : (widget.outlineColor ?? baseColor),
                    width: 1,
                  ),
            // Add shadow when color is white for better visibility in light mode, unless noShadow is true
            boxShadow: widget.noShadow
                ? null
                : (widget.color == Colors.white
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              _isPressed ? 0.05 : 0.1,
                            ),
                            blurRadius: _isPressed ? 2 : 4,
                            offset: Offset(0, _isPressed ? 1 : 2),
                            spreadRadius: 0,
                          ),
                        ]
                      : null),
          ),
          child: Container(
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            child: !isLoading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.leading != null) widget.leading!,
                      if (widget.leading != null) const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.title,
                          style:
                              widget.textStyle ??
                              AppTextStyles.heading3(context).copyWith(
                                fontSize: 16.sp,
                                fontWeight:
                                    FontWeight.w700, // Default font weight
                                color: widget.isDelete
                                    ? deleteTextColor
                                    : isDisabled
                                    ? kcMediumGrey
                                    : (widget.textColor ??
                                          (widget.outlineColor == null &&
                                                  widget.textColor == null
                                              ? Colors.black
                                              : baseColor)),
                              ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.isDelete
                            ? deleteTextColor
                            : isDisabled
                            ? kcMediumGrey
                            : (widget.textColor ??
                                  (widget.outlineColor == null &&
                                          widget.textColor == null
                                      ? Colors.black
                                      : baseColor)),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
