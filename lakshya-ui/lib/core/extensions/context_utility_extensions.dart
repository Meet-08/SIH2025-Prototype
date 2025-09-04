import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extension on BuildContext for utility functions
extension UtilityExtensions on BuildContext {
  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Request focus for a specific focus node
  void requestFocus(FocusNode focusNode) {
    FocusScope.of(this).requestFocus(focusNode);
  }

  /// Get the current focus scope
  FocusScopeNode get focusScope => FocusScope.of(this);

  /// Get the primary focus
  FocusNode? get primaryFocus => FocusScope.of(this).focusedChild;

  /// Check if keyboard is focused
  bool get hasFocus => FocusScope.of(this).hasFocus;

  /// Copy text to clipboard
  Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Get text from clipboard
  Future<String?> getFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    return data?.text;
  }

  /// Provide haptic feedback
  void hapticFeedback({
    HapticFeedbackType type = HapticFeedbackType.selection,
  }) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
      case HapticFeedbackType.vibrate:
        HapticFeedback.vibrate();
        break;
    }
  }

  /// Get the nearest Scaffold
  ScaffoldState get scaffold => Scaffold.of(this);

  /// Get the ScaffoldMessenger
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Get the Form state
  FormState? get form => Form.maybeOf(this);

  /// Get the nearest Scrollable
  ScrollableState? get scrollable => Scrollable.maybeOf(this);

  /// Get the DefaultTabController
  TabController? get tabController => DefaultTabController.maybeOf(this);

  /// Get the ModalRoute
  ModalRoute? get modalRoute => ModalRoute.of(this);

  /// Get route arguments
  Object? get routeArguments => modalRoute?.settings.arguments;

  /// Get route name
  String? get routeName => modalRoute?.settings.name;

  /// Check if route can pop
  bool get canPopRoute => modalRoute?.canPop ?? false;

  /// Get the Directionality
  TextDirection get textDirection => Directionality.of(this);

  /// Check if text direction is RTL
  bool get isRTL => textDirection == TextDirection.rtl;

  /// Check if text direction is LTR
  bool get isLTR => textDirection == TextDirection.ltr;

  /// Get the current locale
  Locale get locale => Localizations.localeOf(this);

  /// Format number with locale
  String formatNumber(num number) {
    // You can add number formatting logic here
    return number.toString();
  }

  /// Format currency with locale
  String formatCurrency(double amount, {String symbol = '₹'}) {
    // You can add currency formatting logic here
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Check if device has dark mode enabled in system
  bool get isSystemDarkMode =>
      MediaQuery.of(this).platformBrightness == Brightness.dark;
}

/// Enum for haptic feedback types
enum HapticFeedbackType { light, medium, heavy, selection, vibrate }
