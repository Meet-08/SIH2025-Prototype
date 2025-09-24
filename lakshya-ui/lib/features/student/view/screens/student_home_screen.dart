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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E88E5), // Primary blue
                Color(0xFF42A5F5), // Primary light blue
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E88E5).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            // Profile picture on the left
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: currentUser?.profilePictureUrl != null
                    ? NetworkImage(currentUser!.profilePictureUrl!)
                    : const AssetImage(
                            'assets/images/Default_Profile_Picture.png',
                          )
                          as ImageProvider,
                backgroundColor: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(width: 16),
            // App name in the center
            const Expanded(
              child: Text(
                'Lakshya',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Logout button on the right
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  // Add logout functionality here
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Add actual logout logic here
                              Navigator.of(context).pop();
                              // Navigate to login screen or perform logout
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  LucideIcons.log_out,
                  color: Colors.white,
                  size: 20,
                ),
                tooltip: 'Logout',
              ),
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      extendBodyBehindAppBar: false,
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
                    // Welcome Section matching the provided image design
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
                                  isDesktop ? 24 : 20,
                                ),
                                child: BackdropFilter(
                                  filter: ui.ImageFilter.blur(
                                    sigmaX: 15,
                                    sigmaY: 15,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(
                                      isDesktop ? 32 : 24,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withValues(alpha: 0.95),
                                          Colors.white.withValues(alpha: 0.85),
                                          AppColors.primaryLight.withValues(
                                            alpha: 0.1,
                                          ),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.08,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 30,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // Left side - Text content
                                        Expanded(
                                          flex: isDesktop ? 5 : 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Main greeting with improved typography
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontSize: isDesktop
                                                        ? 32
                                                        : (isTablet ? 28 : 24),
                                                    fontWeight: FontWeight.w800,
                                                    height: 1.1,
                                                    letterSpacing: -0.8,
                                                    fontFamily:
                                                        'Inter', // Use system font with better readability
                                                  ),
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Hello there,\n',
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .textPrimary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: (() {
                                                        final name =
                                                            currentUser?.name ??
                                                            '';
                                                        final parts = name
                                                            .trim()
                                                            .split(
                                                              RegExp(r'\s+'),
                                                            );
                                                        if (parts.isEmpty ||
                                                            parts[0].isEmpty) {
                                                          return '';
                                                        }
                                                        return parts.length > 1
                                                            ? '${parts[0]} ${parts.last}!'
                                                            : '${parts[0]}!';
                                                      }()),
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        letterSpacing: -1.0,
                                                        shadows: [
                                                          Shadow(
                                                            color: AppColors
                                                                .primary
                                                                .withValues(
                                                                  alpha: 0.2,
                                                                ),
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  2,
                                                                ),
                                                            blurRadius: 4,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: isDesktop ? 20 : 16,
                                              ),
                                              // Improved subtitle with better spacing and typography
                                              Container(
                                                padding: const EdgeInsets.only(
                                                  left: 2,
                                                ),
                                                child: Text(
                                                  'Ready for\nyour next step?',
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: isDesktop
                                                        ? 20
                                                        : (isTablet ? 18 : 16),
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.4,
                                                    letterSpacing: 0.3,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ),
                                              // Add a subtle accent line
                                              SizedBox(
                                                height: isDesktop ? 16 : 12,
                                              ),
                                              Container(
                                                width: 60,
                                                height: 3,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      AppColors.primary,
                                                      AppColors.primary
                                                          .withValues(
                                                            alpha: 0.6,
                                                          ),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: isDesktop ? 20 : 12),
                                        // Right side - Student illustration
                                        Expanded(
                                          flex: isDesktop ? 3 : 2,
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxWidth: isDesktop ? 200 : 150,
                                              maxHeight: isDesktop ? 200 : 150,
                                            ),
                                            child: AspectRatio(
                                              aspectRatio: 1.2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors.primary
                                                          .withValues(
                                                            alpha: 0.08,
                                                          ),
                                                      blurRadius: 20,
                                                      offset: const Offset(
                                                        0,
                                                        8,
                                                      ),
                                                    ),
                                                    BoxShadow(
                                                      color: AppColors.secondary
                                                          .withValues(
                                                            alpha: 0.06,
                                                          ),
                                                      blurRadius: 12,
                                                      offset: const Offset(
                                                        0,
                                                        4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: Image.asset(
                                                    'assets/images/welcome_section.png',
                                                    fit: BoxFit.contain,
                                                    alignment: Alignment.center,
                                                  ),
                                                ),
                                              ),
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
                                              style: TextStyle(
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
                                                    offset: const Offset(0, 0),
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
