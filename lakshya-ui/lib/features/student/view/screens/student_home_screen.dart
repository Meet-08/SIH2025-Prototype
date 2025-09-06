import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/provider/current_user_notifier.dart';
import 'package:lakshya/features/student/view/widgets/feature_card.dart';
import 'package:lakshya/features/student/view/widgets/home_screen_card.dart';

class StudentHomeScreen extends ConsumerStatefulWidget {
  final void Function(int index)? onTap;
  const StudentHomeScreen({super.key, this.onTap});

  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Welcome, ${currentUser!.name}',
                    style: context.textTheme.displaySmall,
                  ),
                ),

                const SizedBox(height: 20),
                const HomeScreenCard(),

                const SizedBox(height: 20),
                FeatureCard(
                  title: "Aptitude Quiz",
                  description:
                      "Discover your strengths and interests. Take or retake the quiz anytime.",
                  icon: Icons.menu_book_rounded,
                  onTap: () => context.pushNamed("/aptitude-quiz"),
                ),
                FeatureCard(
                  title: "Explore your Career Path",
                  description:
                      "Find the best career options tailored to your profile.",
                  icon: CupertinoIcons.compass,
                  onTap: () {
                    //TODO: Navigate to Explore your Career Path Screen
                  },
                ),
                FeatureCard(
                  title: "Colleges",
                  description: "Explore top colleges and universities.",
                  icon: Icons.school,
                  onTap: () => widget.onTap?.call(1),
                ),

                FeatureCard(
                  title: "Scholarships",
                  description: "Find scholarships that suit your profile.",
                  icon: Icons.card_giftcard,
                  onTap: () => widget.onTap?.call(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
