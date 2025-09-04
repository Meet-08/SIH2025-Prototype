import 'package:flutter/material.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/features/onboarding/view/widgets/option_card.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 136,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Text(
                  "Welcome to Lakshya",
                  style: context.textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),
                Text(
                  "Your personal guide to a brighter educational and career future. Let's get started.",
                  style: context.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),
                OptionCard(
                  icon: Icons.person,
                  color: AppColors.collegeGovt,
                  title: "I am a Student",
                  description:
                      "Take a quiz to discover your strengths and get a personalized career roadmap.",
                  buttonText: "Start Your Journey",
                  onPressed: () => context.pushNamed('/student-register'),
                ),

                const SizedBox(height: 18),
                OptionCard(
                  icon: Icons.people,
                  color: AppColors.parentPrimary,
                  title: "I am a Parent",
                  description:
                      "Access resources and guides to help support your child's education and future.",
                  buttonText: "Get Support",
                  onPressed: () => context.pushNamed('/parent-home'),
                ),

                const SizedBox(height: 18),
                Text(
                  "© 2025 Lakshya. All rights reserved.",
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
