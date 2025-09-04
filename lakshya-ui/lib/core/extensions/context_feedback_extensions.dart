import 'package:flutter/material.dart';

/// Extension on BuildContext for showing dialogs, snackbars, and other UI feedback
extension FeedbackExtensions on BuildContext {
  /// Show a snackbar with message
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
    bool showCloseIcon = false,
    IconData? icon,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor ?? Colors.white),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
        ],
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      action: action,
      showCloseIcon: showCloseIcon,
    );

    return ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  /// Show success snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccessSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    return showSnackBar(
      message,
      duration: duration,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  /// Show error snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    return showSnackBar(
      message,
      duration: duration,
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }

  /// Show warning snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showWarningSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    return showSnackBar(
      message,
      duration: duration,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
    );
  }

  /// Show info snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfoSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    return showSnackBar(
      message,
      duration: duration,
      backgroundColor: Colors.blue,
      icon: Icons.info,
    );
  }

  /// Show a simple dialog
  Future<T?> showAlertDialog<T>({
    required String title,
    required String content,
    String confirmText = 'OK',
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog
  Future<bool?> showConfirmationDialog({
    required String title,
    required String content,
    String confirmText = 'Yes',
    String cancelText = 'No',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDangerous
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show loading dialog
  void showLoadingDialog({
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Hide loading dialog (pop the current dialog)
  void hideLoadingDialog() {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    }
  }

  /// Show bottom sheet
  Future<T?> showCustomBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      builder: (context) => child,
    );
  }

  /// Show persistent bottom sheet
  PersistentBottomSheetController showPersistentBottomSheet({
    required Widget child,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
  }) {
    return Scaffold.of(this).showBottomSheet(
      (context) => child,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
    );
  }

  /// Show date picker
  Future<DateTime?> showDatePickerDialog({
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) {
    final now = DateTime.now();
    return showDatePicker(
      context: this,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(now.year - 100),
      lastDate: lastDate ?? DateTime(now.year + 100),
      initialEntryMode: initialEntryMode,
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
    );
  }

  /// Show time picker
  Future<TimeOfDay?> showTimePickerDialog({
    TimeOfDay? initialTime,
    String? helpText,
    String? cancelText,
    String? confirmText,
  }) {
    return showTimePicker(
      context: this,
      initialTime: initialTime ?? TimeOfDay.now(),
      helpText: helpText,
      cancelText: cancelText,
      confirmText: confirmText,
    );
  }
}
