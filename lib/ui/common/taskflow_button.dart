/// Primary button widget with multiple types (primary, secondary, danger), states (enabled, disabled, loading), and outline variant.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskflow/ui/common/app_colors.dart';

enum TaskflowButtonType { primary, secondary, danger }

enum TaskflowButtonState { enabled, disabled, loading }

class TaskflowButton extends StatefulWidget {
  final String title;
  final TaskflowButtonType type;
  final TaskflowButtonState state;
  final void Function()? onTap;
  final bool outline;
  final Widget? leading;
  final double width;
  final double height;
  final Color? color;
  final TextStyle? textStyle;
  final double borderRadius;

  const TaskflowButton({
    super.key,
    required this.title,
    this.type = TaskflowButtonType.primary,
    this.state = TaskflowButtonState.enabled,
    this.onTap,
    this.color,
    this.leading,
    this.width = double.infinity,
    this.height = 50.0,
    this.textStyle,
    this.borderRadius = 26.0,
  }) : outline = false;

  const TaskflowButton.outline({
    super.key,
    required this.title,
    this.onTap,
    this.leading,
    this.color,
    this.textStyle,
    required this.height,
    required this.width,
    this.borderRadius = 26.0,
    this.type = TaskflowButtonType.primary,
    this.state = TaskflowButtonState.enabled,
  }) : outline = true;

  @override
  State<TaskflowButton> createState() => _TaskflowButtonState();
}

class _TaskflowButtonState extends State<TaskflowButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = () {
      if (widget.color != null) return widget.color!;
      switch (widget.type) {
        case TaskflowButtonType.primary:
          return kcPrimaryColor;
        case TaskflowButtonType.secondary:
          return kcDarkGreyColor;
        case TaskflowButtonType.danger:
          return const Color(0xFFD42620);
      }
    }();

    final bool isDisabled = widget.state == TaskflowButtonState.disabled;
    final bool isLoading = widget.state == TaskflowButtonState.loading;
    final bool isEnabled = widget.state == TaskflowButtonState.enabled;
    final bool isInteractive =
        isEnabled; // Only enabled state allows interaction
    final Color fillColor = widget.outline
        ? Colors.transparent
        : (isDisabled || isLoading ? baseColor.withOpacity(0.4) : baseColor);
    final Color borderColor = baseColor;
    final Color labelColor = widget.outline ? baseColor : Colors.white;

    return GestureDetector(
      onTapDown: isInteractive
          ? (_) {
              setState(() {
                _isPressed = true;
              });
            }
          : null,
      onTapUp: isInteractive
          ? (_) {
              // Reset pressed state immediately
              Future.microtask(() {
                if (mounted) {
                  setState(() {
                    _isPressed = false;
                  });
                }
              });
            }
          : null,
      onTapCancel: isInteractive
          ? () {
              setState(() {
                _isPressed = false;
              });
            }
          : null,
      onTap: isInteractive
          ? () {
              // Haptic feedback tuned by type
              if (widget.type == TaskflowButtonType.danger) {
                HapticFeedback.heavyImpact();
              } else {
                HapticFeedback.selectionClick();
              }
              widget.onTap?.call();
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.96 : 1.0)
          ..translate(0.0, _isPressed ? 2.0 : 0.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          decoration: !widget.outline
              ? BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                )
              : BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(color: borderColor, width: 1),
                ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              onTap: isEnabled
                  ? () {
                      // Haptic feedback tuned by type
                      if (widget.type == TaskflowButtonType.danger) {
                        HapticFeedback.heavyImpact();
                      } else {
                        HapticFeedback.selectionClick();
                      }
                      widget.onTap?.call();
                    }
                  : null,
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
                                  Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    fontWeight: widget.outline
                                        ? FontWeight.w500
                                        : FontWeight.bold,
                                    color: labelColor,
                                    fontSize: 16.0,
                                  ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(labelColor),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
