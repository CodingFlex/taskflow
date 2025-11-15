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
      style: ToastificationStyle.flat,
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
      style: ToastificationStyle.flat,
      type: ToastificationType.error,
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

/// Legacy static methods for backward compatibility.
/// These methods create a temporary ToastService instance.
///
/// For new code, prefer injecting ToastService into viewmodels.
class Toast {
  static final _toastService = ToastService();

  /// Show a success toast notification.
  static void showSuccessToast({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _toastService.showSuccess(
      message: message,
      title: title,
      duration: duration,
    );
  }

  /// Show an error toast notification.
  static void showErrorToast({
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    _toastService.showError(
      message: message,
      title: title,
      duration: duration,
    );
  }

  /// Show a success toast for copy operation (legacy method).
  static void showCopySuccess({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _toastService.showSuccess(
      message: message,
      title: 'Copied',
      duration: duration,
    );
  }

  /// Show a "coming soon" toast (legacy method).
  static void showComingSoon({
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _toastService.showSuccess(
      message: message,
      title: 'Coming Soon',
      duration: duration,
    );
  }
}
