import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/provider/current_user_notifier.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends ConsumerState<StudentDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _floatController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatAnimation;
  final ScrollController _scrollController = ScrollController();

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

    // Floating animation for elements
    _floatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _floatAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Start animations
    _backgroundController.repeat(reverse: true);
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _floatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper widget for floating gradient blobs
  Widget _gradientBlob({
    required double size,
    required List<Color> colors,
    double opacity = 0.1,
  }) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              colors.first.withValues(alpha: opacity),
              colors.last.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;
    final horizontalPadding = isDesktop ? 40.0 : (isTablet ? 30.0 : 20.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E88E5), Color(0xFF42A5F5), Color(0xFF64B5F6)],
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
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            GFIconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(LucideIcons.arrow_left, color: Colors.white),
              color: Colors.white.withValues(alpha: 0.2),
              shape: GFIconButtonShape.circle,
              size: GFSize.MEDIUM,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'My Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            GFIconButton(
              onPressed: () {
                // Settings functionality
              },
              icon: const Icon(LucideIcons.pen, color: Colors.white),
              color: Colors.white.withValues(alpha: 0.2),
              shape: GFIconButtonShape.circle,
              size: GFSize.MEDIUM,
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([_backgroundAnimation, _floatAnimation]),
        builder: (context, child) {
          return Stack(
            children: [
              // Animated gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        const Color(0xFFF8F9FF),
                        const Color(0xFFE3F2FD),
                        _backgroundAnimation.value,
                      )!,
                      Color.lerp(
                        const Color(0xFFF0F8FF),
                        const Color(0xFFE8F4FD),
                        _backgroundAnimation.value * 0.7,
                      )!,
                      const Color(0xFFFAFAFA),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Floating gradient blobs
              Positioned(
                top: 100 + _floatAnimation.value,
                right: -50,
                child: _gradientBlob(
                  size: 200,
                  colors: [const Color(0xFF3F51B5), const Color(0xFF5C6BC0)],
                  opacity: 0.05,
                ),
              ),
              Positioned(
                top: 300 - _floatAnimation.value * 0.5,
                left: -80,
                child: _gradientBlob(
                  size: 250,
                  colors: [const Color(0xFFE91E63), const Color(0xFFFF6B9D)],
                  opacity: 0.04,
                ),
              ),
              Positioned(
                bottom: 200 + _floatAnimation.value * 0.8,
                right: -100,
                child: _gradientBlob(
                  size: 180,
                  colors: [const Color(0xFF9C27B0), const Color(0xFFBA68C8)],
                  opacity: 0.06,
                ),
              ),

              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Section
                      Transform.translate(
                        offset: Offset(0, -_floatAnimation.value * 0.3),
                        child: _buildWelcomeSection(user?.name ?? 'Student'),
                      ),
                      const SizedBox(height: 32),

                      // Course Recommendations
                      _buildSectionHeader(
                        'Recommended Courses',
                        LucideIcons.book_open,
                        const Color(0xFF3F51B5), // Timeline screen indigo
                      ),
                      const SizedBox(height: 20),
                      _buildCourseRecommendations(),
                      const SizedBox(height: 32),

                      // College Recommendations
                      _buildSectionHeader(
                        'Top Colleges for You',
                        LucideIcons.graduation_cap,
                        const Color(0xFFE91E63), // College screen pink
                      ),
                      const SizedBox(height: 20),
                      _buildCollegeRecommendations(),
                      const SizedBox(height: 32),

                      // Career Path Recommendations
                      _buildSectionHeader(
                        'Career Opportunities',
                        LucideIcons.briefcase,
                        const Color(0xFF3F51B5), // Timeline screen indigo
                      ),
                      const SizedBox(height: 20),
                      _buildCareerRecommendations(),
                      const SizedBox(height: 32),

                      // Bookmarked Colleges
                      _buildSectionHeader(
                        'Bookmarked Colleges',
                        LucideIcons.bookmark,
                        const Color(0xFFE91E63), // College screen pink
                      ),
                      const SizedBox(height: 20),
                      _buildBookmarkedColleges(context),
                      const SizedBox(height: 32),

                      // Saved Scholarships
                      _buildSectionHeader(
                        'Saved Scholarships',
                        LucideIcons.star,
                        const Color(0xFF9C27B0), // Scholarship screen purple
                      ),
                      const SizedBox(height: 20),
                      _buildSavedScholarships(context),
                      const SizedBox(height: 32),

                      // Recent Activity
                      _buildSectionHeader(
                        'Recent Activity',
                        LucideIcons.activity,
                        const Color(0xFF3F51B5), // Timeline screen indigo
                      ),
                      const SizedBox(height: 20),
                      _buildRecentActivity(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(String userName) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 600;

    return ClipRRect(
      borderRadius: BorderRadius.circular(isDesktop ? 32 : 24),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 28 : 24)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.95),
                Colors.white.withValues(alpha: 0.85),
                const Color(0xFFF8F9FF).withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(isDesktop ? 32 : 24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E88E5).withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.8),
                blurRadius: 20,
                offset: const Offset(-10, -10),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: const Color(0xFF1E88E5).withValues(alpha: 0.05),
                blurRadius: 40,
                offset: const Offset(10, 10),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isDesktop ? 20 : 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1E88E5).withValues(alpha: 0.15),
                          const Color(0xFF1E88E5).withValues(alpha: 0.25),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(isDesktop ? 20 : 16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E88E5).withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.user,
                      color: const Color(0xFF1E88E5),
                      size: isDesktop ? 32 : 28,
                    ),
                  ),
                  SizedBox(width: isDesktop ? 20 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            color: const Color(0xFF666666),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: isDesktop ? 26 : 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E88E5).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      LucideIcons.star,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isDesktop ? 20 : 16),
              Text(
                'Here\'s your personalized dashboard with recommendations tailored just for you. Track your progress and discover new opportunities!',
                style: TextStyle(
                  fontSize: isDesktop ? 18 : 16,
                  color: const Color(0xFF666666),
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.12),
                color.withValues(alpha: 0.25),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseRecommendations() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 600;

    final courses = [
      {
        'title': 'Computer Science Engineering',
        'description': 'Perfect match based on your technical interests',
        'match': '95%',
        'icon': LucideIcons.monitor,
        'color': const Color(0xFF3F51B5), // Timeline screen indigo
      },
      {
        'title': 'Data Science & Analytics',
        'description': 'High demand field matching your analytical skills',
        'match': '88%',
        'icon': LucideIcons.activity,
        'color': const Color(0xFF5C6BC0), // Timeline screen lighter indigo
      },
      {
        'title': 'Artificial Intelligence',
        'description': 'Cutting-edge technology aligned with your goals',
        'match': '85%',
        'icon': LucideIcons.brain,
        'color': const Color(0xFF3F51B5), // Timeline screen indigo
      },
    ];

    return SizedBox(
      height: isDesktop ? 260 : (isTablet ? 240 : 220),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        physics: const BouncingScrollPhysics(),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Transform.translate(
            offset: Offset(
              0,
              -_floatAnimation.value * 0.2 * (index % 2 == 0 ? 1 : -1),
            ),
            child: Container(
              width: isDesktop ? 340 : (isTablet ? 320 : 300),
              margin: EdgeInsets.only(
                right: index < courses.length - 1 ? 20 : 0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isDesktop ? 24 : 20),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.9),
                          Colors.white.withValues(alpha: 0.7),
                          (course['color'] as Color).withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(isDesktop ? 24 : 20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (course['color'] as Color).withValues(
                            alpha: 0.1,
                          ),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 15,
                          offset: const Offset(-8, -8),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isDesktop ? 24 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(isDesktop ? 16 : 12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      (course['color'] as Color).withValues(
                                        alpha: 0.15,
                                      ),
                                      (course['color'] as Color).withValues(
                                        alpha: 0.3,
                                      ),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    isDesktop ? 16 : 12,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (course['color'] as Color)
                                          .withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  course['icon'] as IconData,
                                  color: course['color'] as Color,
                                  size: isDesktop ? 28 : 24,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(
                                        0xFF5C6BC0,
                                      ), // Timeline screen lighter indigo
                                      Color(
                                        0xFF3F51B5,
                                      ), // Timeline screen indigo
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF5C6BC0,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  course['match'] as String,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isDesktop ? 14 : 13,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isDesktop ? 16 : 12),
                          Text(
                            course['title'] as String,
                            style: TextStyle(
                              fontSize: isDesktop ? 18 : 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A1A),
                              letterSpacing: -0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: isDesktop ? 10 : 8),
                          Text(
                            course['description'] as String,
                            style: TextStyle(
                              fontSize: isDesktop ? 15 : 14,
                              color: const Color(0xFF666666),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Container(
                            width: double.infinity,
                            height: isDesktop ? 48 : 44,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  course['color'] as Color,
                                  (course['color'] as Color).withValues(
                                    alpha: 0.8,
                                  ),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                isDesktop ? 18 : 16,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (course['color'] as Color).withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    isDesktop ? 18 : 16,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Learn More',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: isDesktop ? 16 : 15,
                                  letterSpacing: 0.3,
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
    );
  }

  Widget _buildCollegeRecommendations() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 600;

    final colleges = [
      {
        'name': 'LDCE',
        'location': 'Ahmedabad',
        'ranking': '#1',
        'icon': LucideIcons.building_2,
        'type': 'Government',
        'color': const Color(0xFFE91E63), // College screen pink
      },
      {
        'name': 'VGEC',
        'location': 'Ahmedabad',
        'ranking': '#2',
        'icon': LucideIcons.graduation_cap,
        'type': 'Government',
        'color': const Color(0xFFFF6B9D), // College screen light pink
      },
    ];

    return Column(
      children: colleges.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> college = entry.value;
        final collegeColor = college['color'] as Color;

        return Transform.translate(
          offset: Offset(
            0,
            -_floatAnimation.value * 0.15 * (index % 2 == 0 ? 1 : -1),
          ),
          child: Container(
            margin: EdgeInsets.only(bottom: isDesktop ? 20 : 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDesktop ? 24 : 20),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.9),
                        Colors.white.withValues(alpha: 0.7),
                        collegeColor.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(isDesktop ? 24 : 20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: collegeColor.withValues(alpha: 0.1),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.9),
                        blurRadius: 15,
                        offset: const Offset(-8, -8),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(
                      isDesktop ? 24 : (isTablet ? 22 : 20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isDesktop ? 20 : 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                collegeColor.withValues(alpha: 0.15),
                                collegeColor.withValues(alpha: 0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              isDesktop ? 20 : 16,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: collegeColor.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            college['icon'] as IconData,
                            color: collegeColor,
                            size: isDesktop ? 32 : 28,
                          ),
                        ),
                        SizedBox(width: isDesktop ? 20 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      college['name'] as String,
                                      style: TextStyle(
                                        fontSize: isDesktop ? 18 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1A1A1A),
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isDesktop ? 12 : 10,
                                      vertical: isDesktop ? 6 : 5,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          collegeColor,
                                          collegeColor.withValues(alpha: 0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: collegeColor.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      college['ranking'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                college['location'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                collegeColor,
                                collegeColor.withValues(alpha: 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              isDesktop ? 20 : 16,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: collegeColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 20 : 16,
                                vertical: isDesktop ? 14 : 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  isDesktop ? 20 : 16,
                                ),
                              ),
                            ),
                            child: Text(
                              'View Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: isDesktop ? 15 : 14,
                                letterSpacing: 0.3,
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
      }).toList(),
    );
  }

  Widget _buildCareerRecommendations() {
    final careers = [
      {
        'title': 'Software Engineer',
        'growth': '+22%',
        'salary': '₹8-15 LPA',
        'icon': LucideIcons.code,
        'color': const Color(0xFF3F51B5), // Timeline screen indigo
      },
      {
        'title': 'Data Scientist',
        'growth': '+31%',
        'salary': '₹12-25 LPA',
        'icon': LucideIcons.database,
        'color': const Color(0xFF5C6BC0), // Timeline screen lighter indigo
      },
      {
        'title': 'AI/ML Engineer',
        'growth': '+40%',
        'salary': '₹15-30 LPA',
        'icon': LucideIcons.brain,
        'color': const Color(0xFF3F51B5), // Timeline screen indigo
      },
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: careers.length,
        itemBuilder: (context, index) {
          final career = careers[index];
          return Container(
            width: 200,
            height: 160,
            margin: EdgeInsets.only(right: index < careers.length - 1 ? 16 : 0),
            child: Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (career['color'] as Color).withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            career['icon'] as IconData,
                            color: career['color'] as Color,
                            size: 18,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFE91E63,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            career['growth'] as String,
                            style: const TextStyle(
                              color: Color(0xFFE91E63),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      career['title'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      career['salary'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
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

  Widget _buildRecentActivity() {
    final activities = [
      {
        'title': 'Completed Aptitude Assessment',
        'time': '2 hours ago',
        'icon': LucideIcons.gift,
        'color': const Color(0xFF3F51B5), // Timeline screen indigo
      },
      {
        'title': 'Viewed LDCE Details',
        'time': '1 day ago',
        'icon': LucideIcons.eye,
        'color': const Color(0xFFE91E63), // College screen pink
      },
      {
        'title': 'Applied for Merit Scholarship',
        'time': '3 days ago',
        'icon': LucideIcons.send,
        'color': const Color(0xFF9C27B0), // Scholarship screen purple
      },
    ];

    return Column(
      children: activities.map((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFFAFBFF)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (activity['color'] as Color).withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.9),
                blurRadius: 6,
                offset: const Offset(-2, -2),
              ),
            ],
            border: Border.all(
              color: (activity['color'] as Color).withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (activity['color'] as Color).withValues(alpha: 0.15),
                      (activity['color'] as Color).withValues(alpha: 0.25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (activity['color'] as Color).withValues(
                        alpha: 0.2,
                      ),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  activity['icon'] as IconData,
                  color: activity['color'] as Color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activity['time'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF666666).withValues(alpha: 0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBookmarkedColleges(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFAFBFF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFFE91E63,
            ).withValues(alpha: 0.1), // College screen pink
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.9),
            blurRadius: 8,
            offset: const Offset(-3, -3),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE91E63).withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFE91E63).withValues(alpha: 0.15),
                      const Color(0xFFE91E63).withValues(alpha: 0.25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.graduation_cap,
                  color: Color(0xFFE91E63),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Saved Colleges',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Quick access to your bookmarked colleges',
                      style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE91E63),
                      const Color(0xFFE91E63).withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed('/colleges');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        LucideIcons.arrow_right,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.bookmark,
                  color: const Color(0xFFE91E63).withValues(alpha: 0.7),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '5 colleges bookmarked • Last updated 2 hours ago',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedScholarships(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFFFBF0)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF9C27B0,
            ).withValues(alpha: 0.1), // Scholarship screen purple
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.9),
            blurRadius: 8,
            offset: const Offset(-3, -3),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF9C27B0).withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF9C27B0).withValues(alpha: 0.15),
                      const Color(0xFF9C27B0).withValues(alpha: 0.25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.gift,
                  color: Color(0xFF9C27B0),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Saved Scholarships',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track application deadlines and requirements',
                      style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9C27B0),
                      const Color(0xFF9C27B0).withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed('/scholarship');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        LucideIcons.arrow_right,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.star,
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.7),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '8 scholarships saved • 3 deadlines this month',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                    ),
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
