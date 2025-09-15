import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/provider/current_user_notifier.dart';
import 'package:lakshya/features/student/view/widgets/feature_card.dart';

class StudentHomeScreen extends ConsumerStatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => print('Profile Tapped'),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: currentUser?.profilePictureUrl != null
                      ? NetworkImage(currentUser!.profilePictureUrl!)
                      : const AssetImage(
                              'assets/images/Default_Profile_Picture.png',
                            )
                            as ImageProvider,
                ),
              ),
            ),
            GFIconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Row(
                      children: [
                        Icon(
                          LucideIcons.log_out,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text('Confirm Logout'),
                      ],
                    ),
                    content: const Text(
                      'Are you sure you want to log out?',
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.pop();
                          ref
                              .read(currentUserNotifierProvider.notifier)
                              .logout();
                          if (mounted) {
                            context.pushNamedAndRemoveUntil(
                              '/student-login',
                              (route) => false,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                LucideIcons.log_out,
                color: Colors.white,
                size: 24,
              ),
              color: Colors.white.withValues(alpha: 0.2),
              shape: GFIconButtonShape.circle,
              size: GFSize.MEDIUM,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withValues(alpha: 0.05),
              AppColors.background,
              AppColors.background,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with Welcome Message
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: AppGradients.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              LucideIcons.sparkles,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome back!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentUser?.name ?? 'Student',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ready to explore your career journey? Let\'s discover what\'s waiting for you!',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Features Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: AppGradients.primaryGradient,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Explore Features',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Feature Cards in Grid Layout
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                        children: [
                          FeatureCard(
                            title: "Aptitude Quiz",
                            description:
                                "Discover your strengths and interests. Take or retake the quiz anytime.",
                            icon: LucideIcons.brain,
                            onTap: () => context.pushNamed("/aptitude-quiz"),
                          ),
                          FeatureCard(
                            title: "Explore Career",
                            description:
                                "Find the best career options tailored to your profile.",
                            icon: LucideIcons.compass,
                            onTap: () =>
                                context.pushNamed("/course-to-career-mapping"),
                          ),
                          FeatureCard(
                            title: "Colleges",
                            description:
                                "Explore top colleges and universities that match your goals.",
                            icon: LucideIcons.graduation_cap,
                            onTap: () => context.pushNamed("/colleges"),
                          ),
                          FeatureCard(
                            title: "Scholarships",
                            description:
                                "Find scholarships and financial aid that suit your profile.",
                            icon: LucideIcons.gift,
                            onTap: () => context.pushNamed("/scholarship"),
                          ),
                          FeatureCard(
                            title: "Timeline",
                            description:
                                "Keep track of important deadlines and milestones.",
                            icon: LucideIcons.calendar_check,
                            onTap: () => context.pushNamed("/timeline"),
                          ),
                          FeatureCard(
                            title: "Resources",
                            description:
                                "Access study materials and career guidance resources.",
                            icon: LucideIcons.book_open,
                            onTap: () => print('Resources Tapped'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
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
