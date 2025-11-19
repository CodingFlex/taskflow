import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:taskflow/ui/common/text_styles.dart';
import 'package:taskflow/ui/common/ui_helpers.dart';

/// Animated error message widget that appears below form fields with fade and slide transitions.
class AnimatedFieldError extends StatelessWidget {
  final String? errorMessage;
  final Color color;
  final IconData icon;

  const AnimatedFieldError({
    super.key,
    this.errorMessage,
    this.color = Colors.red,
    this.icon = FontAwesomeIcons.circleExclamation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, -0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            ),
          );
        },
        child: errorMessage != null && errorMessage!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                key: ValueKey(errorMessage),
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 16),
                    horizontalSpaceSmall,
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: AppTextStyles.caption(
                          context,
                        ).copyWith(color: color, fontSize: 10.sp),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(key: ValueKey('empty')),
      ),
    );
  }
}
