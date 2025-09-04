import 'package:flutter/material.dart';
import 'package:lakshya/core/theme/app_colors.dart';
import 'package:lakshya/core/theme/app_widgets.dart';
import 'package:lakshya/preview/extensions_demo.dart';
import 'package:lakshya/preview/feature_demo_page.dart';
import 'package:lakshya/preview/theme_demo_page.dart';

class LakshyaHomePage extends StatelessWidget {
  const LakshyaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lakshya - Career Guidance'),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(Icons.school, size: 64, color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      'Welcome to Lakshya',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your Complete Career Guidance Platform',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Feature Highlights
              const Text(
                'Explore Our Features',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              // Demo Buttons
              AppWidgets.ctaButton(
                text: 'View App Features Demo',
                icon: Icons.featured_play_list,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeatureDemoPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemeDemoPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.palette),
                label: const Text('View Color Theme Demo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.onSecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExtensionsDemo(),
                    ),
                  );
                },
                icon: const Icon(Icons.extension),
                label: const Text('View Context Extensions Demo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Feature List
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Key Features:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildFeatureItem(
                                '🧠 Aptitude & Interest Quiz',
                                'Personalized career mapping based on your interests',
                              ),
                              _buildFeatureItem(
                                '🎯 Course-to-Career Path Mapping',
                                'Visual roadmaps showing career progression',
                              ),
                              _buildFeatureItem(
                                '🏫 Nearby Government Colleges',
                                'Location-based college directory with details',
                              ),
                              _buildFeatureItem(
                                '💰 Scholarship & Govt Schemes',
                                'Complete scholarship information and deadlines',
                              ),
                              _buildFeatureItem(
                                '📅 Timeline & Notifications',
                                'Important dates and deadline tracking',
                              ),
                              _buildFeatureItem(
                                '👨‍👩‍👧‍👦 For Parents',
                                'Dedicated dashboard for parental guidance',
                              ),
                              _buildFeatureItem(
                                '🌐 Multi-language Support',
                                'Available in English, Hindi, and regional languages',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.split(' ')[0], // Extract emoji
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.substring(title.indexOf(' ') + 1), // Remove emoji
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
