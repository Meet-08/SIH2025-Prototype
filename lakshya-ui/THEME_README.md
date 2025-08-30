# Lakshya - Career Guidance App Color Theme

A comprehensive Flutter color theme designed specifically for the Lakshya career guidance application, supporting multiple features including aptitude tests, career mapping, college directory, scholarships, and parental guidance.

## Color Palette Overview

### Primary Colors (Trust & Professionalism)

- **Primary Blue**: `#1E88E5` - Main brand color, used for headers, primary buttons, and highlights
- **Primary Dark**: `#1565C0` - Darker shade for depth and contrast
- **Primary Light**: `#42A5F5` - Lighter shade for subtle backgrounds
- **Primary Container**: `#BBDEFB` - Container backgrounds

### Secondary Colors (Growth & Positivity)

- **Secondary Green**: `#43A047` - Represents growth and career opportunities
- **Secondary Dark**: `#2E7D32` - Used for progress indicators and success states
- **Secondary Light**: `#66BB6A` - Career highlights and positive feedback
- **Secondary Container**: `#C8E6C9` - Success message backgrounds

### Accent Colors (Energy & Youth)

- **Accent Orange**: `#FFB300` - Call-to-action buttons and highlights
- **Accent Dark**: `#FB8C00` - Hover states and active elements
- **Accent Light**: `#FFCC02` - Subtle accents and decorations
- **Accent Container**: `#FFF3C4` - Warning and notification backgrounds

### Neutral Colors

- **Background**: `#FAFAFA` - Main app background
- **Surface**: `#FFFFFF` - Card and component backgrounds
- **Surface Variant**: `#F5F5F5` - Alternative surface colors
- **Text Primary**: `#1C1B1F` - Main text color
- **Text Secondary**: `#49454E` - Secondary text and descriptions

## Feature-Specific Color Schemes

### Quiz & Assessment

- **Quiz Correct**: `#4CAF50` - Correct answer indicators
- **Quiz Incorrect**: `#FF5722` - Incorrect answer indicators
- **Quiz Neutral**: `#9E9E9E` - Neutral options
- **Quiz Background**: `#F8F9FA` - Question card backgrounds

### Interest Domains

- **Logical Domain**: `#3F51B5` (Indigo) - Mathematics, analytical thinking
- **Creative Domain**: `#E91E63` (Pink) - Art, design, creative expression
- **Social Domain**: `#4CAF50` (Green) - People interaction, social causes
- **Technical Domain**: `#2196F3` (Blue) - Engineering, technology
- **Business Domain**: `#FF9800` (Orange) - Entrepreneurship, management
- **Scientific Domain**: `#9C27B0` (Purple) - Research, science

### Career Roadmap

- **Roadmap Completed**: `#4CAF50` - Completed milestones
- **Roadmap Current**: `#FFB300` - Current stage
- **Roadmap Future**: `#E0E0E0` - Future milestones
- **Roadmap Connection**: `#BDBDBD` - Connecting lines

### College Directory

- **College Government**: `#1976D2` - Government institutions
- **College Private**: `#7B1FA2` - Private institutions
- **College Location**: `#388E3C` - Location indicators
- **College Fees**: `#D32F2F` - Fee information

### Scholarships & Schemes

- **Scholarship Active**: `#2E7D32` - Active scholarships
- **Scholarship Expiring**: `#FF8F00` - Soon-to-expire deadlines
- **Scholarship Expired**: `#616161` - Past deadlines

### Timeline & Notifications

- **Timeline Upcoming**: `#FFB300` - Upcoming events
- **Timeline Active**: `#43A047` - Current events
- **Timeline Past**: `#BDBDBD` - Completed events
- **Notification High**: `#D32F2F` - High priority alerts
- **Notification Medium**: `#FF8F00` - Medium priority alerts
- **Notification Low**: `#1976D2` - Low priority alerts

### Parent Dashboard

- **Parent Primary**: `#5E35B1` - Main parent dashboard color
- **Parent Secondary**: `#26A69A` - Secondary elements
- **Parent Accent**: `#FFCA28` - Accent elements
- **Parent Info**: `#42A5F5` - Information displays

### Multi-Language Support

- **Language English**: `#1976D2` - English language indicator
- **Language Hindi**: `#FF6F00` - Hindi language indicator
- **Language Regional**: `#388E3C` - Regional language indicators

## Usage Guidelines

### Theme Implementation

```dart
// Import the theme
import 'package:lakshya/theme/theme.dart';

// Apply the theme to MaterialApp
MaterialApp(
  theme: AppTheme.lightTheme,
  // ... rest of your app
)
```

### Using Colors

```dart
// Access colors directly
Container(
  color: AppColors.primary,
  child: Text(
    'Header Text',
    style: TextStyle(color: AppColors.onPrimary),
  ),
)

// Use feature-specific colors
FeatureWidgets.quizQuestionCard(
  // Automatically uses quiz-specific colors
)
```

### Custom Gradients

```dart
// Apply feature-specific gradients
Container(
  decoration: BoxDecoration(
    gradient: AppGradients.careerRoadmapGradient,
  ),
)
```

## Accessibility Considerations

- **Contrast Ratios**: All text-background combinations meet WCAG AA standards
- **Color Blindness**: Color combinations are distinguishable for common color vision deficiencies
- **Material Design 3**: Full compliance with Material 3 design system
- **Dark Mode**: Framework ready for dark theme implementation

## Component Library

The theme includes pre-built widgets for all major features:

### Quiz Components

- `FeatureWidgets.quizQuestionCard()` - Interactive quiz questions
- `FeatureWidgets.interestDomainCard()` - Interest analysis results

### Career Planning

- `FeatureWidgets.careerRoadmapNode()` - Roadmap milestones
- `AppWidgets.progressBar()` - Progress indicators

### Educational Resources

- `FeatureWidgets.collegeCard()` - College information display
- `FeatureWidgets.scholarshipCard()` - Scholarship details

### Timeline & Tracking

- `FeatureWidgets.timelineEventCard()` - Important dates
- Notification components with priority-based colors

### Parent Features

- `FeatureWidgets.parentInfoCard()` - Parent dashboard widgets
- Analytics and progress tracking components

### Internationalization

- `FeatureWidgets.languageSelector()` - Multi-language support
- RTL layout considerations

## File Structure

```
lib/
  theme/
    ├── app_colors.dart       # Color definitions
    ├── app_theme.dart        # Theme configuration
    ├── app_widgets.dart      # General widgets
    ├── feature_widgets.dart  # Feature-specific widgets
    └── theme.dart           # Export file
```

## Customization

The theme is designed to be easily customizable. To modify colors:

1. Update color values in `app_colors.dart`
2. Modify gradients in the same file
3. Adjust widget styles in `app_theme.dart`
4. Create custom widgets in `feature_widgets.dart`

## Best Practices

1. **Consistency**: Always use defined colors instead of hardcoded values
2. **Semantics**: Use feature-specific colors for better user understanding
3. **Accessibility**: Test color combinations for proper contrast
4. **Scalability**: Add new colors following the established naming convention
5. **Performance**: Gradients and shadows are optimized for smooth animations

## Demo Pages

The project includes comprehensive demo pages:

- `FeatureDemoPage` - Showcases all feature-specific widgets
- `ThemeDemoPage` - Displays the complete color palette and components

Run the app to explore the interactive demos and see the theme in action!

## Future Enhancements

- Dark theme implementation
- High contrast mode
- Additional regional language support
- Animated color transitions
- Custom Material 3 dynamic color support
