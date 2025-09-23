import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/provider/current_user_notifier.dart';
import 'package:lakshya/core/theme/app_text_styles.dart';
import 'package:lakshya/features/student/view/widgets/feature_card.dart';

class StudentHomeScreen extends ConsumerStatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _headerController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Background gradient animation
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Header entrance animation
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _headerSlideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.elasticOut),
    );
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animations
    _backgroundController.repeat(reverse: true);
    _headerController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    // Responsive grid calculations
    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 2);
    final childAspectRatio = isDesktop ? 0.8 : (isTablet ? 0.7 : 0.65);
    final horizontalPadding = isDesktop ? 40.0 : (isTablet ? 30.0 : 20.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFFE0F7FA),
                    const Color(0xFFF0F4FF),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFFB2EBF2),
                    const Color(0xFFE1E7FF),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF80DEEA),
                    const Color(0xFFB8C5FF),
                    _backgroundAnimation.value,
                  )!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated Header Section with enhanced styling
                    AnimatedBuilder(
                      animation: _headerController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _headerSlideAnimation.value),
                          child: Opacity(
                            opacity: _headerFadeAnimation.value,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(
                                0,
                                isDesktop ? 30 : 20,
                                0,
                                isDesktop ? 40 : 30,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  isDesktop ? 50 : 40,
                                ),
                                child: BackdropFilter(
                                  filter: ui.ImageFilter.blur(
                                    sigmaX: 20,
                                    sigmaY: 20,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isDesktop ? 24 : 18,
                                      vertical: isDesktop ? 18 : 14,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient:
                                          AppGradients.brandHeaderGradient,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, -5),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Enhanced multi-ring avatar
                                        Container(
                                          width: isDesktop ? 70 : 58,
                                          height: isDesktop ? 70 : 58,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                AppColors.accent,
                                                AppColors.primary,
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.2,
                                                ),
                                                blurRadius: 15,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  AppColors.secondary,
                                                  AppColors.secondaryDark,
                                                ],
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(3),
                                            child: CircleAvatar(
                                              radius: isDesktop ? 30 : 24,
                                              backgroundImage:
                                                  currentUser
                                                          ?.profilePictureUrl !=
                                                      null
                                                  ? NetworkImage(
                                                      currentUser!
                                                          .profilePictureUrl!,
                                                    )
                                                  : const AssetImage(
                                                          'assets/images/Default_Profile_Picture.png',
                                                        )
                                                        as ImageProvider,
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                    255,
                                                    154,
                                                    189,
                                                    195,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: isDesktop ? 18 : 14),
                                        // Enhanced text section
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    LucideIcons.sparkles,
                                                    color:
                                                        AppColors.accentLight,
                                                    size: isDesktop ? 20 : 18,
                                                  ),
                                                  SizedBox(
                                                    width: isDesktop ? 10 : 8,
                                                  ),
                                                  Text(
                                                    'Welcome back!',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: isDesktop
                                                          ? 20
                                                          : 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      shadows: [
                                                        Shadow(
                                                          color: Colors.black
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                          offset: const Offset(
                                                            0,
                                                            1,
                                                          ),
                                                          blurRadius: 2,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: isDesktop ? 6 : 4,
                                              ),
                                              Text(
                                                "${currentUser!.name.split(" ")[0]} ${currentUser.name.split(" ").length > 1 ? currentUser.name.split(" ")[1] : ''}",
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.95),
                                                  fontSize: isDesktop ? 18 : 16,
                                                  fontWeight: FontWeight.w600,
                                                  shadows: [
                                                    Shadow(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                      offset: const Offset(
                                                        0,
                                                        1,
                                                      ),
                                                      blurRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Enhanced action button
                                        Container(
                                          width: isDesktop ? 52 : 46,
                                          height: isDesktop ? 52 : 46,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withValues(
                                              alpha: 0.15,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              width: 1.8,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.1,
                                                ),
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              LucideIcons.arrow_right,
                                              color: Colors.white,
                                              size: isDesktop ? 26 : 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Image Box Section
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, isDesktop ? 30 : 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          isDesktop ? 24 : 20,
                        ),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.3),
                                  Colors.white.withValues(alpha: 0.1),
                                  AppColors.primaryLight.withValues(alpha: 0.2),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  blurRadius: 15,
                                  offset: const Offset(0, -3),
                                ),
                              ],
                            ),
                            child: AspectRatio(
                              aspectRatio: isDesktop
                                  ? (16 / 9)
                                  : (isTablet ? (4 / 3) : (3 / 4)),
                              child: Stack(
                                children: [
                                  // Background image with subtle tint
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.primary.withValues(
                                              alpha: 0.1,
                                            ),
                                            AppColors.secondary.withValues(
                                              alpha: 0.1,
                                            ),
                                            AppColors.accent.withValues(
                                              alpha: 0.1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/images/hero.png',
                                        fit: BoxFit.cover,
                                        // Slight upward bias to keep subject centered nicely
                                        alignment: const Alignment(0, -0.05),
                                      ),
                                    ),
                                  ),
                                  // Overlay content
                                  Positioned(
                                    bottom: isDesktop ? 20 : 15,
                                    left: isDesktop ? 24 : 20,
                                    right: isDesktop ? 24 : 20,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isDesktop ? 16 : 12,
                                        vertical: isDesktop ? 12 : 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            LucideIcons.trending_up,
                                            color: AppColors.accentLight,
                                            size: isDesktop ? 20 : 16,
                                          ),
                                          SizedBox(width: isDesktop ? 12 : 8),
                                          Expanded(
                                            child: Text(
                                              'Your journey to success starts here!',
                                              style: AppTextStyles.body
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontSize: isDesktop
                                                        ? 18
                                                        : (isTablet ? 16 : 14),
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.15,
                                                    height: 1.2,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black
                                                            .withValues(
                                                              alpha: 0.55,
                                                            ),
                                                        offset: const Offset(
                                                          0,
                                                          1.25,
                                                        ),
                                                        blurRadius: 2.5,
                                                      ),
                                                      Shadow(
                                                        color: Colors.black
                                                            .withValues(
                                                              alpha: 0.25,
                                                            ),
                                                        offset: const Offset(
                                                          0,
                                                          0,
                                                        ),
                                                        blurRadius: 1,
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
                        ),
                      ),
                    ),

                    // Enhanced Features Section
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section header with glassmorphism
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 24 : 20,
                              vertical: isDesktop ? 16 : 12,
                            ),
                            margin: EdgeInsets.only(
                              bottom: isDesktop ? 32 : 24,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppGradients.surfaceAccent,
                              borderRadius: BorderRadius.circular(
                                isDesktop ? 20 : 16,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(isDesktop ? 10 : 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(
                                      isDesktop ? 14 : 12,
                                    ),
                                  ),
                                  child: Icon(
                                    LucideIcons.grid_3x3,
                                    color: const Color(0xFF0F172A),
                                    size: isDesktop ? 24 : 20,
                                  ),
                                ),
                                SizedBox(width: isDesktop ? 16 : 12),
                                Text(
                                  'Explore Features',
                                  style: TextStyle(
                                    fontSize: isDesktop
                                        ? 26
                                        : (isTablet ? 24 : 22),
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                    shadows: [
                                      Shadow(
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Enhanced responsive grid layout
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return GridView.count(
                                crossAxisCount: crossAxisCount,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: isDesktop
                                    ? 24
                                    : (isTablet ? 20 : 16),
                                mainAxisSpacing: isDesktop
                                    ? 24
                                    : (isTablet ? 20 : 16),
                                childAspectRatio: childAspectRatio,
                                padding: EdgeInsets.symmetric(
                                  vertical: isDesktop ? 12 : 8,
                                ),
                                children: [
                                  FeatureCard(
                                    title: "Aptitude\nQuiz",
                                    description:
                                        "Find career paths matched to your strengths",
                                    icon: LucideIcons.brain,
                                    accentGradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF00CEC9),
                                        Color(0xFF4ADEAA),
                                      ],
                                    ),
                                    accentColor: const Color(0xFF00CEC9),
                                    onTap: () =>
                                        context.pushNamed("/aptitude-quiz"),
                                  ),
                                  FeatureCard(
                                    title: "Career Roadmap",
                                    description:
                                        "Step-by-step guidance to your dream career",
                                    icon: LucideIcons.map,
                                    accentGradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFF9500),
                                        Color(0xFFFF6B35),
                                      ],
                                    ),
                                    accentColor: const Color.fromARGB(
                                      255,
                                      255,
                                      157,
                                      21,
                                    ),
                                    onTap: () => context.pushNamed(
                                      "/course-to-career-mapping",
                                    ),
                                  ),
                                  FeatureCard(
                                    title: "Nearby Colleges",
                                    description:
                                        "Discover colleges tailored to your goals",
                                    icon: LucideIcons.graduation_cap,
                                    accentGradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFE91E63),
                                        Color(0xFFFF6B9D),
                                      ],
                                    ),
                                    accentColor: const Color(0xFFE91E63),
                                    onTap: () => context.pushNamed("/colleges"),
                                  ),
                                  FeatureCard(
                                    title: "Scholarships",
                                    description:
                                        "Find scholarships and financial aid opportunities",
                                    icon: LucideIcons.award,
                                    accentGradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF9C27B0),
                                        Color(0xFFBA68C8),
                                      ],
                                    ),
                                    accentColor: const Color(0xFF9C27B0),
                                    onTap: () =>
                                        context.pushNamed("/scholarship"),
                                  ),
                                  FeatureCard(
                                    title: "Timeline",
                                    description:
                                        "Track your academic and career milestones",
                                    icon: LucideIcons.calendar,
                                    accentGradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF3F51B5),
                                        Color(0xFF5C6BC0),
                                      ],
                                    ),
                                    accentColor: const Color(0xFF3F51B5),
                                    onTap: () => context.pushNamed("/timeline"),
                                  ),
                                  FeatureCard(
                                    title: "Resources",
                                    description:
                                        "Access study materials and career resources",
                                    icon: LucideIcons.book_open,
                                    accentGradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF00BCD4),
                                        Color(0xFF26C6DA),
                                      ],
                                    ),
                                    accentColor: const Color(0xFF00BCD4),
                                    onTap: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
                              );
                            },
                          ),

                          SizedBox(height: isDesktop ? 40 : 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
