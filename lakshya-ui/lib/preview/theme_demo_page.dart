// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../core/core.dart';

class ThemeDemoPage extends StatelessWidget {
  const ThemeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lakshya Theme Demo'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color Palette Section
            _buildSectionTitle('Color Palette'),
            _buildColorPalette(),
            const SizedBox(height: 24),

            // Buttons Section
            _buildSectionTitle('Buttons'),
            _buildButtonsDemo(),
            const SizedBox(height: 24),

            // Progress Bars Section
            _buildSectionTitle('Progress Indicators'),
            _buildProgressDemo(),
            const SizedBox(height: 24),

            // Custom Widgets Section
            _buildSectionTitle('Custom Widgets'),
            _buildCustomWidgetsDemo(),
            const SizedBox(height: 24),

            // Cards Section
            _buildSectionTitle('Cards'),
            _buildCardsDemo(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildColorPalette() {
    return Column(
      children: [
        Row(
          children: [
            _buildColorCard('Primary', AppColors.primary),
            const SizedBox(width: 8),
            _buildColorCard('Primary Dark', AppColors.primaryDark),
            const SizedBox(width: 8),
            _buildColorCard('Primary Light', AppColors.primaryLight),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildColorCard('Secondary', AppColors.secondary),
            const SizedBox(width: 8),
            _buildColorCard('Secondary Dark', AppColors.secondaryDark),
            const SizedBox(width: 8),
            _buildColorCard('Secondary Light', AppColors.secondaryLight),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildColorCard('Accent', AppColors.accent),
            const SizedBox(width: 8),
            _buildColorCard('Accent Dark', AppColors.accentDark),
            const SizedBox(width: 8),
            _buildColorCard('Accent Light', AppColors.accentLight),
          ],
        ),
      ],
    );
  }

  Widget _buildColorCard(String name, Color color) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: _getContrastColor(color),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Color _getContrastColor(Color color) {
    // Simple contrast calculation
    final luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  Widget _buildButtonsDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Primary Button'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            TextButton(onPressed: () {}, child: const Text('Text Button')),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: AppButtonStyles.successButtonStyle,
              child: const Text('Success Button'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppWidgets.ctaButton(
          text: 'Take Aptitude Quiz',
          icon: Icons.quiz,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildProgressDemo() {
    return Column(
      children: [
        AppWidgets.progressBar(progress: 0.7, label: 'Profile Completion'),
        const SizedBox(height: 16),
        AppWidgets.progressBar(
          progress: 0.45,
          label: 'Skill Development',
          color: AppColors.secondary,
        ),
        const SizedBox(height: 16),
        AppWidgets.progressBar(
          progress: 0.9,
          label: 'Career Readiness',
          color: AppColors.accent,
        ),
      ],
    );
  }

  Widget _buildCustomWidgetsDemo() {
    return Column(
      children: [
        AppWidgets.successMessage(
          message: 'Congratulations! You have completed your profile setup.',
        ),
        const SizedBox(height: 16),
        AppWidgets.infoCard(
          title: 'Career Guidance',
          icon: Icons.school,
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get personalized career recommendations based on your interests, skills, and aptitude test results.',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              SizedBox(height: 12),
              Text(
                '• Take comprehensive aptitude tests\n'
                '• Explore career paths\n'
                '• Get skill recommendations\n'
                '• Connect with mentors',
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardsDemo() {
    return Column(
      children: [
        AppWidgets.careerCard(
          title: 'Software Engineering',
          description:
              'Design, develop, and maintain software applications. Work with cutting-edge technologies and solve complex problems.',
          tags: ['Technology', 'Programming', 'Problem Solving'],
          onTap: () {},
        ),
        const SizedBox(height: 16),
        AppWidgets.careerCard(
          title: 'Data Science',
          description:
              'Analyze complex data sets to derive insights and make data-driven decisions. Combine statistics, programming, and domain expertise.',
          tags: ['Analytics', 'Machine Learning', 'Statistics'],
          onTap: () {},
        ),
      ],
    );
  }
}
