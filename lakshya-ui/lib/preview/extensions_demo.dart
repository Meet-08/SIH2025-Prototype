// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../core/extensions/extensions.dart';

class ExtensionsDemo extends StatefulWidget {
  const ExtensionsDemo({super.key});

  @override
  State<ExtensionsDemo> createState() => _ExtensionsDemoState();
}

class _ExtensionsDemoState extends State<ExtensionsDemo> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Context Extensions Demo'),
        backgroundColor: context.primaryColor,
        foregroundColor: context.onPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: context.responsivePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Extensions Demo
            _buildSectionTitle('Theme Extensions'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme Information',
                      style: context.titleLarge?.copyWith(
                        color: context.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Primary Color',
                      _colorToHex(context.primaryColor),
                    ),
                    _buildInfoRow(
                      'Secondary Color',
                      _colorToHex(context.secondaryColor),
                    ),
                    _buildInfoRow(
                      'Surface Color',
                      _colorToHex(context.surfaceColor),
                    ),
                    _buildInfoRow(
                      'Is Dark Mode',
                      context.isDarkMode.toString(),
                    ),
                    _buildInfoRow('Text Direction', context.textDirection.name),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Media Query Extensions Demo
            _buildSectionTitle('Media Query Extensions'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Screen Information',
                      style: context.titleLarge?.copyWith(
                        color: context.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Screen Size',
                      '${context.screenWidth.toInt()} x ${context.screenHeight.toInt()}',
                    ),
                    _buildInfoRow('Screen Type', context.screenType.name),
                    _buildInfoRow('Orientation', context.orientation.name),
                    _buildInfoRow(
                      'Status Bar Height',
                      context.statusBarHeight.toStringAsFixed(1),
                    ),
                    _buildInfoRow(
                      'Is Keyboard Visible',
                      context.isKeyboardVisible.toString(),
                    ),
                    _buildInfoRow(
                      'Safe Area Height',
                      context.safeAreaHeight.toStringAsFixed(1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Navigation Extensions Demo
            _buildSectionTitle('Navigation Extensions'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.pushMaterialRoute(
                      const _DemoPage(title: 'Pushed Page'),
                      routeName: '/demo',
                    );
                  },
                  child: const Text('Push New Page'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.pushReplacementMaterialRoute(
                      const _DemoPage(title: 'Replacement Page'),
                      routeName: '/replacement',
                    );
                  },
                  child: const Text('Push Replacement'),
                ),
                ElevatedButton(
                  onPressed: context.canPop ? () => context.pop() : null,
                  child: const Text('Pop'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Feedback Extensions Demo
            _buildSectionTitle('Feedback Extensions'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.showSuccessSnackBar('Success message!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Success SnackBar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.showErrorSnackBar('Error message!');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Error SnackBar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.showWarningSnackBar('Warning message!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Warning SnackBar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.showInfoSnackBar('Info message!');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Info SnackBar'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await context.showConfirmationDialog(
                      title: 'Confirmation',
                      content: 'Are you sure you want to continue?',
                    );
                    if (result == true && mounted) {
                      context.showSuccessSnackBar('Confirmed!');
                    }
                  },
                  child: const Text('Show Confirmation'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final date = await context.showDatePickerDialog();
                    if (date != null && mounted) {
                      context.showInfoSnackBar('Selected: ${date.toLocal()}');
                    }
                  },
                  child: const Text('Pick Date'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final time = await context.showTimePickerDialog();
                    if (time != null && mounted) {
                      context.showInfoSnackBar(
                        'Selected: ${time.format(context)}',
                      );
                    }
                  },
                  child: const Text('Pick Time'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Utility Extensions Demo
            _buildSectionTitle('Utility Extensions'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Utility Functions',
                      style: context.titleLarge?.copyWith(
                        color: context.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Test Input',
                        hintText: 'Type something here...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.hideKeyboard();
                          },
                          child: const Text('Hide Keyboard'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.requestFocus(_focusNode);
                          },
                          child: const Text('Focus Input'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.copyToClipboard(_textController.text);
                            context.showSuccessSnackBar('Copied to clipboard!');
                          },
                          child: const Text('Copy Text'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final text = await context.getFromClipboard();
                            if (text != null) {
                              _textController.text = text;
                              context.showSuccessSnackBar(
                                'Pasted from clipboard!',
                              );
                            }
                          },
                          child: const Text('Paste Text'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.hapticFeedback(
                              type: HapticFeedbackType.medium,
                            );
                            context.showInfoSnackBar(
                              'Haptic feedback triggered!',
                            );
                          },
                          child: const Text('Haptic Feedback'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Current Locale', context.locale.toString()),
                    _buildInfoRow('Is RTL', context.isRTL.toString()),
                    _buildInfoRow('Has Focus', context.hasFocus.toString()),
                    _buildInfoRow('Route Name', context.routeName ?? 'Unknown'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Responsive Demo
            _buildSectionTitle('Responsive Extensions'),
            Card(
              child: Padding(
                padding: context.responsivePadding(
                  mobile: 16,
                  tablet: 24,
                  desktop: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Responsive Layout',
                      style: context
                          .responsiveValue(
                            mobile: context.titleMedium,
                            tablet: context.titleLarge,
                            desktop: context.headlineSmall,
                          )
                          ?.copyWith(color: context.primaryColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This card has responsive padding that changes based on screen size. '
                      'The title also changes size responsively.',
                      style: context.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: context.responsiveValue<double>(
                        mobile: 100,
                        tablet: 120,
                        desktop: 150,
                      ),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: context.primaryColor),
                      ),
                      child: Center(
                        child: Text(
                          'Responsive Container\n'
                          'Height: ${context.responsiveValue<double>(mobile: 100, tablet: 120, desktop: 150)}px',
                          textAlign: TextAlign.center,
                          style: context.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.showCustomBottomSheet(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Bottom Sheet Demo', style: context.titleLarge),
                  const SizedBox(height: 16),
                  Text(
                    'This is a custom bottom sheet shown using context extensions!',
                    style: context.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.open_in_new),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: context.headlineSmall?.copyWith(
          color: context.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: context.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value, style: context.bodyMedium)),
        ],
      ),
    );
  }

  String _colorToHex(Color color) {
    // ignore: deprecated_member_use
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}

class _DemoPage extends StatelessWidget {
  final String title;

  const _DemoPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: context.secondaryColor,
        foregroundColor: context.onSecondaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: context.headlineMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go Back'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.popToRoot(),
              child: const Text('Pop to Root'),
            ),
          ],
        ),
      ),
    );
  }
}
