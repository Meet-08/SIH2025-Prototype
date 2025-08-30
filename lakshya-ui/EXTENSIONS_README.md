# Context Extensions for Flutter

A comprehensive set of extensions for `BuildContext` that simplify common Flutter operations and improve code readability. These extensions provide convenient shortcuts for navigation, theming, media queries, feedback, and utility functions.

## 🚀 Features

### 📱 Navigation Extensions

Simplify navigation operations with intuitive method names.

### 🎨 Theme Extensions

Easy access to theme data, colors, and text styles.

### 📐 Media Query Extensions

Responsive design utilities and screen information.

### 💬 Feedback Extensions

Show snackbars, dialogs, and date/time pickers with ease.

### 🔧 Utility Extensions

Keyboard management, clipboard operations, haptic feedback, and more.

## 📋 Usage Examples

### Navigation Extensions

```dart
// Instead of Navigator.of(context).push(...)
context.pushMaterialRoute(SomePage());

// Instead of Navigator.of(context).pushNamed(...)
context.pushNamed('/some-route');

// Instead of Navigator.of(context).pop()
context.pop();

// Push and replace current route
context.pushReplacementMaterialRoute(NewPage());

// Pop to root
context.popToRoot();

// Check if can pop
if (context.canPop) {
  context.pop();
}
```

### Theme Extensions

```dart
// Instead of Theme.of(context).colorScheme.primary
Container(
  color: context.primaryColor,
  child: Text(
    'Hello',
    style: TextStyle(color: context.onPrimaryColor),
  ),
)

// Easy access to text styles
Text(
  'Title',
  style: context.titleLarge?.copyWith(
    color: context.primaryColor,
  ),
)

// Check theme mode
if (context.isDarkMode) {
  // Dark mode specific logic
}
```

### Media Query Extensions

```dart
// Instead of MediaQuery.of(context).size.width
double width = context.screenWidth;
double height = context.screenHeight;

// Screen type detection
if (context.isMobile) {
  // Mobile specific layout
} else if (context.isTablet) {
  // Tablet specific layout
} else if (context.isDesktop) {
  // Desktop specific layout
}

// Responsive values
double padding = context.responsiveValue(
  mobile: 16.0,
  tablet: 24.0,
  desktop: 32.0,
);

// Responsive padding
Padding(
  padding: context.responsivePadding(
    mobile: 16,
    tablet: 24,
    desktop: 32,
  ),
  child: child,
)

// Check keyboard visibility
if (context.isKeyboardVisible) {
  // Keyboard is open
}

// Get safe area dimensions
double safeHeight = context.safeAreaHeight;
double statusBarHeight = context.statusBarHeight;
```

### Feedback Extensions

```dart
// Show different types of snackbars
context.showSuccessSnackBar('Operation completed!');
context.showErrorSnackBar('Something went wrong!');
context.showWarningSnackBar('Please check your input');
context.showInfoSnackBar('Information message');

// Custom snackbar
context.showSnackBar(
  'Custom message',
  backgroundColor: Colors.blue,
  icon: Icons.info,
  duration: Duration(seconds: 3),
);

// Show confirmation dialog
final result = await context.showConfirmationDialog(
  title: 'Delete Item',
  content: 'Are you sure you want to delete this item?',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  isDangerous: true,
);

if (result == true) {
  // User confirmed
}

// Show alert dialog
context.showAlertDialog(
  title: 'Alert',
  content: 'This is an alert message',
  onConfirm: () {
    // Handle confirmation
  },
);

// Show loading dialog
context.showLoadingDialog(message: 'Please wait...');
// Later...
context.hideLoadingDialog();

// Show bottom sheet
context.showCustomBottomSheet(
  child: Container(
    padding: EdgeInsets.all(24),
    child: Text('Bottom sheet content'),
  ),
);

// Date and time pickers
final date = await context.showDatePickerDialog();
final time = await context.showTimePickerDialog();
```

### Utility Extensions

```dart
// Hide keyboard
context.hideKeyboard();

// Focus management
context.requestFocus(myFocusNode);

// Clipboard operations
await context.copyToClipboard('Text to copy');
final clipboardText = await context.getFromClipboard();

// Haptic feedback
context.hapticFeedback(type: HapticFeedbackType.medium);

// Check focus state
if (context.hasFocus) {
  // Widget tree has focus
}

// Get locale information
Locale currentLocale = context.locale;
bool isRTL = context.isRTL;

// Format values
String formattedCurrency = context.formatCurrency(123.45); // ₹123.45
```

## 📚 Available Extensions

### 1. Navigation Extensions (`context_navigation_extensions.dart`)

- `push()`, `pushNamed()`, `pushReplacement()`, `pushReplacementNamed()`
- `pushAndRemoveUntil()`, `pushNamedAndRemoveUntil()`
- `pop()`, `popUntil()`, `popToRoot()`
- `canPop`, `pushMaterialRoute()`, `pushReplacementMaterialRoute()`

### 2. Theme Extensions (`context_theme_extensions.dart`)

- Color scheme access: `primaryColor`, `secondaryColor`, `surfaceColor`, etc.
- Text theme access: `titleLarge`, `bodyMedium`, `headlineSmall`, etc.
- Theme state: `isDarkMode`, `isLightMode`
- Component themes: `appBarTheme`, `cardTheme`, etc.

### 3. Media Query Extensions (`context_media_query_extensions.dart`)

- Screen dimensions: `screenWidth`, `screenHeight`, `screenSize`
- Screen type detection: `isMobile`, `isTablet`, `isDesktop`
- Orientation: `isLandscape`, `isPortrait`
- Safe area: `safeAreaHeight`, `statusBarHeight`, `bottomPadding`
- Keyboard: `isKeyboardVisible`, `keyboardHeight`
- Responsive utilities: `responsiveValue()`, `responsivePadding()`

### 4. Feedback Extensions (`context_feedback_extensions.dart`)

- Snackbars: `showSuccessSnackBar()`, `showErrorSnackBar()`, etc.
- Dialogs: `showAlertDialog()`, `showConfirmationDialog()`, `showLoadingDialog()`
- Bottom sheets: `showCustomBottomSheet()`, `showPersistentBottomSheet()`
- Pickers: `showDatePickerDialog()`, `showTimePickerDialog()`

### 5. Utility Extensions (`context_utility_extensions.dart`)

- Keyboard: `hideKeyboard()`, `requestFocus()`
- Clipboard: `copyToClipboard()`, `getFromClipboard()`
- Haptic feedback: `hapticFeedback()`
- Focus management: `hasFocus`, `focusScope`
- Locale: `locale`, `isRTL`, `isLTR`
- Widget tree: `getInheritedWidget()`, `findAncestorWidget()`
- Formatting: `formatNumber()`, `formatCurrency()`

## 🎯 Screen Type Breakpoints

```dart
enum ScreenType {
  mobile,   // < 600px width
  tablet,   // 600px - 1024px width
  desktop,  // > 1024px width
}
```

## 🔧 Haptic Feedback Types

```dart
enum HapticFeedbackType {
  light,      // Light impact
  medium,     // Medium impact
  heavy,      // Heavy impact
  selection,  // Selection click
  vibrate,    // General vibration
}
```

## 💡 Best Practices

1. **Import once**: Import the extensions package once in your main file or create a barrel export
2. **Consistent usage**: Use extensions consistently throughout your app for better maintainability
3. **Responsive design**: Leverage responsive utilities for better multi-platform support
4. **Error handling**: Always handle potential null returns from async operations
5. **Performance**: Extensions don't add runtime overhead as they're resolved at compile time

## 📦 Installation

Simply add the extensions to your project:

```dart
import 'package:your_app/core/extensions/extensions.dart';
```

## 🧪 Testing

The extensions are fully testable. You can mock `BuildContext` and test the extension methods:

```dart
// Example test
testWidgets('should navigate to new page', (tester) async {
  await tester.pumpWidget(MyApp());

  // Find a button that uses context.pushMaterialRoute()
  final button = find.byType(ElevatedButton);
  await tester.tap(button);
  await tester.pumpAndSettle();

  // Verify navigation occurred
  expect(find.text('New Page'), findsOneWidget);
});
```

## 🚀 Benefits

- **Reduced boilerplate**: Less code to write and maintain
- **Better readability**: More intuitive method names
- **Type safety**: Full type safety with IDE support
- **Consistency**: Uniform API across the entire app
- **Productivity**: Faster development with helpful shortcuts
- **Maintainability**: Centralized logic for common operations

## 📱 Demo

Run the `ExtensionsDemo` page to see all extensions in action:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ExtensionsDemo(),
  ),
);
```

The demo showcases:

- Real-time theme information
- Screen dimension details
- Interactive navigation examples
- All types of feedback widgets
- Utility function demonstrations
- Responsive layout examples
