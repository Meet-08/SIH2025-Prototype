import 'package:flutter/material.dart';

/// Color constants for the Lakshya application
/// Based on Trust & Professionalism theme with blue as primary color
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors (Trust & Professionalism) - Blue shades
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryContainer = Color(0xFFBBDEFB);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF0D47A1);

  // Secondary Colors (Growth & Positivity) - Green shades
  static const Color secondary = Color(0xFF43A047);
  static const Color secondaryDark = Color(0xFF2E7D32);
  static const Color secondaryLight = Color(0xFF66BB6A);
  static const Color secondaryContainer = Color(0xFFC8E6C9);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF1B5E20);

  // Accent Colors (Energy & Youth) - Orange/Yellow shades
  static const Color accent = Color(0xFFFFB300);
  static const Color accentDark = Color(0xFFFB8C00);
  static const Color accentLight = Color(0xFFFFCC02);
  static const Color accentContainer = Color(0xFFFFF3C4);
  static const Color onAccent = Color(0xFF000000);
  static const Color onAccentContainer = Color(0xFF663C00);

  // Neutral/Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color surfaceContainer = Color(0xFFEEEEEE);
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454E);

  // Error Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF410002);

  // Outline Colors
  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  // Shadow and Scrim
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454E);
  static const Color textTertiary = Color(0xFF79747E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  // Specific use case colors
  static const Color progressBar = secondary;
  static const Color successMessage = secondary;
  static const Color careerHighlight = secondaryLight;
  static const Color ctaButton = accent;
  static const Color cardBackground = surface;
  static const Color divider = outlineVariant;

  // Feature-specific colors

  // Quiz & Assessment colors
  static const Color quizCorrect = Color(0xFF4CAF50);
  static const Color quizIncorrect = Color(0xFFFF5722);
  static const Color quizNeutral = Color(0xFF9E9E9E);
  static const Color quizBackground = Color(0xFFF8F9FA);

  // Career roadmap colors
  static const Color roadmapNode = primary;
  static const Color roadmapConnection = Color(0xFFBDBDBD);
  static const Color roadmapCompleted = secondary;
  static const Color roadmapCurrent = accent;
  static const Color roadmapFuture = Color(0xFFE0E0E0);

  // Interest domain colors
  static const Color logicalDomain = Color(0xFF3F51B5); // Indigo
  static const Color creativeDomain = Color(0xFFE91E63); // Pink
  static const Color socialDomain = Color(0xFF4CAF50); // Green
  static const Color technicalDomain = Color(0xFF2196F3); // Blue
  static const Color businessDomain = Color(0xFFFF9800); // Orange
  static const Color scientificDomain = Color(0xFF9C27B0); // Purple

  // College & Education colors
  static const Color collegeGovt = Color(0xFF1976D2);
  static const Color collegePrivate = Color(0xFF7B1FA2);
  static const Color collegeLocation = Color(0xFF388E3C);
  static const Color collegeFees = Color(0xFFD32F2F);

  // Scholarship & Scheme colors
  static const Color scholarshipActive = Color(0xFF2E7D32);
  static const Color scholarshipExpiring = Color(0xFFFF8F00);
  static const Color scholarshipExpired = Color(0xFF616161);

  // Timeline & Notification colors
  static const Color timelineUpcoming = accent;
  static const Color timelineActive = secondary;
  static const Color timelinePast = Color(0xFFBDBDBD);
  static const Color notificationHigh = Color(0xFFD32F2F);
  static const Color notificationMedium = Color(0xFFFF8F00);
  static const Color notificationLow = Color(0xFF1976D2);

  // Parent dashboard colors
  static const Color parentPrimary = Color(0xFF5E35B1);
  static const Color parentSecondary = Color(0xFF26A69A);
  static const Color parentAccent = Color(0xFFFFCA28);
  static const Color parentInfo = Color(0xFF42A5F5);

  // Chart & Graph colors
  static const List<Color> chartColors = [
    Color(0xFF1E88E5), // Blue
    Color(0xFF43A047), // Green
    Color(0xFFFFB300), // Orange
    Color(0xFFE53935), // Red
    Color(0xFF8E24AA), // Purple
    Color(0xFF00ACC1), // Cyan
    Color(0xFFFF7043), // Deep Orange
    Color(0xFF5E35B1), // Deep Purple
  ];

  // Status colors
  static const Color statusCompleted = Color(0xFF4CAF50);
  static const Color statusInProgress = Color(0xFF2196F3);
  static const Color statusPending = Color(0xFFFF9800);
  static const Color statusBlocked = Color(0xFFE91E63);

  // Language support colors
  static const Color languageEnglish = Color(0xFF1976D2);
  static const Color languageHindi = Color(0xFFFF6F00);
  static const Color languageRegional = Color(0xFF388E3C);
}

/// Gradient definitions for the app
class AppGradients {
  AppGradients._();

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [AppColors.secondary, AppColors.secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [AppColors.accent, AppColors.accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [AppColors.background, AppColors.surfaceVariant],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Feature-specific gradients
  static const LinearGradient quizGradient = LinearGradient(
    colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient careerRoadmapGradient = LinearGradient(
    colors: [
      Color(0xFF8E24AA), // Vivid Purple (Creativity & Ambition)
      Color(0xFF5E35B1), // Deep Indigo (Stability & Professionalism)
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient scholarshipGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient timelineGradient = LinearGradient(
    colors: [AppColors.accent, AppColors.accentDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
