import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0F7FA), // Light cyan
              Color(0xFFB2EBF2), // Medium cyan
              Color(0xFF80DEEA), // Slightly deeper cyan
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with Welcome Message (Capsule style)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40), // pill shape
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: const BoxDecoration(
                        gradient: AppGradients.brandHeaderGradient,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Multi-ring avatar (outer cyan→purple, inner orange→pink)
                          Container(
                            width: 58,
                            height: 58,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF22D3EE), Color(0xFF8B5CF6)],
                              ),
                            ),
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFB703),
                                    Color(0xFFFB5607),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    currentUser?.profilePictureUrl != null
                                    ? NetworkImage(
                                        currentUser!.profilePictureUrl!,
                                      )
                                    : const AssetImage(
                                            'assets/images/Default_Profile_Picture.png',
                                          )
                                          as ImageProvider,
                                backgroundColor: const ui.Color.fromARGB(
                                  255,
                                  154,
                                  189,
                                  195,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Texts
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.sparkles,
                                      color: Color(0xFFFACC15), // yellow accent
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Welcome back!',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${currentUser!.name.split(" ")[0]} ${currentUser.name.split(" ").length > 1 ? currentUser.name.split(" ")[1] : ''}",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Right circular outline button
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.75),
                                width: 1.6,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                LucideIcons.arrow_right,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF8B5CF6,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              LucideIcons.grid_3x3,
                              color: Color(0xFF8B5CF6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Explore Features',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
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
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.6,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          FeatureCard(
                            title: "Aptitude\n Quiz",
                            description:
                                "Find career paths matched to your strengths",
                            icon: LucideIcons.brain,
                            accentGradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF00CEC9), Color(0xFF4ADEAA)],
                            ),
                            accentColor: const Color(0xFF00CEC9),
                            onTap: () => context.pushNamed("/aptitude-quiz"),
                          ),
                          FeatureCard(
                            title: "Career Roadmap",
                            description:
                                "Step-by-step guidance to your dream career",
                            icon: LucideIcons.map,
                            accentGradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFF9500), Color(0xFFFF6B35)],
                            ),
                            accentColor: const ui.Color.fromARGB(
                              255,
                              255,
                              157,
                              21,
                            ),
                            onTap: () =>
                                context.pushNamed("/course-to-career-mapping"),
                          ),
                          FeatureCard(
                            title: "Nearby Colleges",
                            description:
                                "Discover colleges tailored to your goals",
                            icon: LucideIcons.graduation_cap,
                            accentGradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFE91E63), Color(0xFFFF6B9D)],
                            ),
                            accentColor: const ui.Color.fromARGB(
                              255,
                              230,
                              99,
                              143,
                            ),
                            onTap: () => context.pushNamed("/colleges"),
                          ),
                          FeatureCard(
                            title: "Find Scholarships",
                            description:
                                "Find financial aid to support your studies",
                            icon: LucideIcons.award,
                            accentGradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF8B5CF6), Color(0xFFBB6BD9)],
                            ),
                            accentColor: const Color(0xFF8B5CF6),
                            onTap: () => context.pushNamed("/scholarship"),
                          ),
                          FeatureCard(
                            title: "Timeline",
                            description:
                                "Get personalized reminders for important deadlines",
                            icon: LucideIcons.calendar,
                            accentGradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF60A5FA), Color(0xFF22D3EE)],
                            ),
                            accentColor: const Color(0xFF60A5FA),
                            onTap: () => context.pushNamed("/timeline"),
                          ),
                          FeatureCard(
                            title: "Resources",
                            description:
                                "Access study materials and career guidance resources.",
                            icon: LucideIcons.book_open,
                            accentGradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ui.Color.fromARGB(255, 255, 209, 140),
                                ui.Color.fromARGB(255, 255, 211, 146),
                              ],
                            ),
                            accentColor: const Color(0xFFFFA726),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Resources feature is coming soon',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
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
