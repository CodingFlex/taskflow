import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:stacked_services/stacked_services.dart';

/// Service for showing toast notifications using the toastification package.
///
/// This service provides methods to show success and error toasts
/// using ToastificationStyle.flat style. It can be used from viewmodels
/// without requiring a BuildContext.
class ToastService {
  /// Show a success toast notification.
  ///
  /// [message] - The message to display in the toast
  /// [title] - Optional title for the toast (defaults to "Success")
  /// [duration] - How long the toast should be displayed (defaults to 3 seconds)
  void showSuccess({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final context = _getContext();
    if (context == null) return;

    toastification.show(
      context: context,
      title: Text(title ?? 'Success'),
      description: Text(message),
      style: ToastificationStyle.flatColored,
      type: ToastificationType.success,
      autoCloseDuration: duration,
      alignment: Alignment.topRight,
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
