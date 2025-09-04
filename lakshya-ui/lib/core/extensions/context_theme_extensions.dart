import 'package:flutter/material.dart';

/// Extension on BuildContext for convenient access to theme data
extension ThemeExtensions on BuildContext {
  /// Get the current theme data
  ThemeData get theme => Theme.of(this);

  /// Get the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Primary colors
  Color get primaryColor => colorScheme.primary;
  Color get onPrimaryColor => colorScheme.onPrimary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;

  /// Secondary colors
  Color get secondaryColor => colorScheme.secondary;
  Color get onSecondaryColor => colorScheme.onSecondary;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;

  /// Tertiary colors
  Color get tertiaryColor => colorScheme.tertiary;
  Color get onTertiaryColor => colorScheme.onTertiary;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;

  /// Surface colors
  Color get surfaceColor => colorScheme.surface;
  Color get onSurfaceColor => colorScheme.onSurface;
  Color get surfaceVariant => colorScheme.surfaceContainerHighest;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;

  /// Background colors
  Color get backgroundColor => colorScheme.surface;
  Color get onBackgroundColor => colorScheme.onSurface;

  /// Error colors
  Color get errorColor => colorScheme.error;
  Color get onErrorColor => colorScheme.onError;
  Color get errorContainer => colorScheme.errorContainer;
  Color get onErrorContainer => colorScheme.onErrorContainer;

  /// Outline colors
  Color get outlineColor => colorScheme.outline;
  Color get outlineVariant => colorScheme.outlineVariant;

  /// Shadow and scrim
  Color get shadowColor => colorScheme.shadow;
  Color get scrimColor => colorScheme.scrim;

  /// Text styles shortcuts
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;

  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;

  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;

  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;

  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;

  /// Check if current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Check if current theme is light
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  /// Get app bar theme
  AppBarThemeData get appBarTheme => Theme.of(this).appBarTheme;

  /// Get card theme
  CardThemeData get cardTheme => Theme.of(this).cardTheme;

  /// Get elevated button theme
  ElevatedButtonThemeData get elevatedButtonTheme =>
      Theme.of(this).elevatedButtonTheme;

  /// Get outlined button theme
  OutlinedButtonThemeData get outlinedButtonTheme =>
      Theme.of(this).outlinedButtonTheme;

  /// Get text button theme
  TextButtonThemeData get textButtonTheme => Theme.of(this).textButtonTheme;

  /// Get input decoration theme
  InputDecorationThemeData get inputDecorationTheme =>
      Theme.of(this).inputDecorationTheme;

  /// Get floating action button theme
  FloatingActionButtonThemeData get fabTheme =>
      Theme.of(this).floatingActionButtonTheme;

  /// Get bottom navigation bar theme
  BottomNavigationBarThemeData get bottomNavTheme =>
      Theme.of(this).bottomNavigationBarTheme;

  /// Get icon theme
  IconThemeData get iconTheme => Theme.of(this).iconTheme;

  /// Get primary icon theme
  IconThemeData get primaryIconTheme => Theme.of(this).primaryIconTheme;
}
