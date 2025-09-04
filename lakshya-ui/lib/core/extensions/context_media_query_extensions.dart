import 'package:flutter/material.dart';

/// Extension on BuildContext for convenient access to MediaQuery data
extension MediaQueryExtensions on BuildContext {
  /// Get the current media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => mediaQuery.size.width;

  /// Get screen height
  double get screenHeight => mediaQuery.size.height;

  /// Get device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Get text scale factor
  double get textScaleFactor => mediaQuery.textScaler.scale(1.0);

  /// Get platform brightness
  Brightness get platformBrightness => mediaQuery.platformBrightness;

  /// Get padding (status bar, navigation bar, etc.)
  EdgeInsets get padding => mediaQuery.padding;

  /// Get view insets (keyboard, etc.)
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Get view padding
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// Get status bar height
  double get statusBarHeight => mediaQuery.padding.top;

  /// Get bottom padding (navigation bar)
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Get safe area height (excluding status bar and navigation bar)
  double get safeAreaHeight => screenHeight - statusBarHeight - bottomPadding;

  /// Get safe area width
  double get safeAreaWidth => screenWidth;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Get keyboard height
  double get keyboardHeight => viewInsets.bottom;

  /// Screen type based on width breakpoints
  ScreenType get screenType {
    if (screenWidth < 600) return ScreenType.mobile;
    if (screenWidth < 1024) return ScreenType.tablet;
    return ScreenType.desktop;
  }

  /// Check if current device is mobile
  bool get isMobile => screenType == ScreenType.mobile;

  /// Check if current device is tablet
  bool get isTablet => screenType == ScreenType.tablet;

  /// Check if current device is desktop
  bool get isDesktop => screenType == ScreenType.desktop;

  /// Check if screen is in landscape orientation
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Check if screen is in portrait orientation
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  /// Get orientation
  Orientation get orientation => mediaQuery.orientation;

  /// Responsive value based on screen type
  T responsiveValue<T>({required T mobile, T? tablet, T? desktop}) {
    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Get responsive padding
  EdgeInsets responsivePadding({
    double mobile = 16.0,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return EdgeInsets.all(value);
  }

  /// Get responsive horizontal padding
  EdgeInsets responsiveHorizontalPadding({
    double mobile = 16.0,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return EdgeInsets.symmetric(horizontal: value);
  }

  /// Get responsive vertical padding
  EdgeInsets responsiveVerticalPadding({
    double mobile = 16.0,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveValue(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return EdgeInsets.symmetric(vertical: value);
  }
}

/// Screen type enumeration
enum ScreenType { mobile, tablet, desktop }
