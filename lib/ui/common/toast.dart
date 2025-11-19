/// Service for displaying toast notifications (success, error, info) with optional undo functionality for success toasts.
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:stacked_services/stacked_services.dart';

class ToastService {
  /// Show a success toast notification.
  ///
  /// [message] - The message to display in the toast
  /// [title] - Optional title for the toast (defaults to "Success")
  /// [duration] - How long the toast should be displayed (defaults to 3 seconds)
  /// [onUndoPressed] - Optional callback for "Undo" button. If provided, shows undo button
  void showSuccess({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onUndoPressed,
  }) {
    final context = _getContext();
    if (context == null) return;

    toastification.show(
      context: context,
      title: Text(title ?? 'Success'),
      description: onUndoPressed != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Text(message)),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    toastification.dismissAll();
                    onUndoPressed();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'UNDO',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            )
          : Text(message),
      style: ToastificationStyle.flat,
      type: ToastificationType.success,
      autoCloseDuration: duration,
      alignment: Alignment.topRight,
      showProgressBar: onUndoPressed != null,
    );
  }

  /// Show an error toast notification.
  ///
  /// [message] - The message to display in the toast
  /// [title] - Optional title for the toast (defaults to "Error")
  /// [duration] - How long the toast should be displayed (defaults to 4 seconds)
  void showError({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    final context = _getContext();
    if (context == null) return;

    toastification.show(
      context: context,
      title: Text(title ?? 'Error'),
      description: Text(message),
      style: ToastificationStyle.flatColored,
      type: ToastificationType.error,
      autoCloseDuration: duration,
      alignment: Alignment.topRight,
    );
  }

  /// Show an info toast notification.
  ///
  /// [message] - The message to display in the toast
  /// [title] - Optional title for the toast (defaults to "Info")
  /// [duration] - How long the toast should be displayed (defaults to 3 seconds)
  void showInfo({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final context = _getContext();
    if (context == null) return;

    toastification.show(
      context: context,
      title: Text(title ?? 'Info'),
      description: Text(message),
      style: ToastificationStyle.flatColored,
      type: ToastificationType.info,
      autoCloseDuration: duration,
      alignment: Alignment.topRight,
    );
  }

  /// Get the current BuildContext from the navigator key.
  ///
  /// Returns null if no context is available.
  BuildContext? _getContext() {
    return StackedService.navigatorKey?.currentContext;
  }
}
