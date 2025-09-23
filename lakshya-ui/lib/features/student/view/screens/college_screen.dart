import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/theme/app_text_styles.dart';
import 'package:lakshya/features/student/viewmodel/college_view_model.dart';

class CollegeScreen extends ConsumerStatefulWidget {
  const CollegeScreen({super.key});

  @override
  ConsumerState<CollegeScreen> createState() => _CollegeScreenState();
}

class _CollegeScreenState extends ConsumerState<CollegeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late AnimationController _backgroundController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatAnimation;
  @override
  void initState() {
    super.initState();

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    _floatAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Start animations
    _backgroundController.repeat(reverse: true);
    _floatController.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(collegeViewModelProvider.notifier).fetchColleges();
      if (mounted) {
        _fadeAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _backgroundController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              colors: [
                Color(0xFFE91E63), // College card pink
                Color(0xFFFF6B9D), // College card light pink
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE91E63).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
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
                'Colleges',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GFIconButton(
              onPressed: () {
                // Add filter/search functionality here
              },
              icon: const Icon(
                LucideIcons.sliders_horizontal,
                color: Colors.white,
              ),
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
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFFFFE4E8), // Light pink
                    const Color(0xFFE8F4FF), // Light blue
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFFFFCDD2), // Pink
                    const Color(0xFFE1E7FF), // Light purple
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFFFF9CAF), // Deeper pink
                    const Color(0xFFB8C5FF), // Light blue-purple
                    _backgroundAnimation.value,
                  )!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child:
                    ref
                        .watch(collegeViewModelProvider)
                        ?.when(
                          data: (colleges) {
                            if (colleges.isEmpty) {
                              return _buildEmptyState();
                            }
                            return _buildCollegesList(colleges);
                          },
                          loading: () => _buildLoadingState(),
                          error: (error, stack) =>
                              _buildErrorState(error.toString()),
                        ) ??
                    _buildLoadingState(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Center(
      child: Transform.translate(
        offset: Offset(0, -_floatAnimation.value * 0.5),
        child: Container(
          margin: EdgeInsets.all(isDesktop ? 40 : 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDesktop ? 32 : 24),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: EdgeInsets.all(isDesktop ? 48 : 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.9),
                      Colors.white.withValues(alpha: 0.7),
                      const Color(0xFFFFE4E8).withValues(alpha: 0.8),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: -5,
                      offset: const Offset(0, 20),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 40,
                      spreadRadius: -10,
                      offset: const Offset(0, 25),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 32 : 24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE91E63), Color(0xFFFF6B9D)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFE91E63,
                            ).withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        LucideIcons.search_x,
                        size: isDesktop ? 80 : 64,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 32 : 24),
                    Text(
                      'No colleges found',
                      style: AppTextStyles.h1.copyWith(
                        fontSize: isDesktop ? 28 : (isTablet ? 24 : 20),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFE91E63),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 16 : 8),
                    Text(
                      'Try adjusting your search criteria',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        fontSize: isDesktop ? 18 : 16,
                        color: AppColors.textSecondary,
                        height: 1.4,
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
  }

  Widget _buildLoadingState() {
    return Center(
      child: Transform.translate(
        offset: Offset(0, -_floatAnimation.value * 0.5),
        child: Container(
          margin: const EdgeInsets.all(24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.9),
                      Colors.white.withValues(alpha: 0.7),
                      const Color(0xFFFFE4E8).withValues(alpha: 0.8),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: -5,
                      offset: const Offset(0, 20),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 40,
                      spreadRadius: -10,
                      offset: const Offset(0, 25),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const GFLoader(
                      type: GFLoaderType.ios,
                      loaderColorOne: Color(0xFFE91E63),
                      loaderColorTwo: Color(0xFFFF6B9D),
                      loaderColorThree: Color(0xFFFF9CAF),
                      size: GFSize.MEDIUM,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Loading colleges...',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 16,
                        color: const Color(0xFFE91E63),
                        fontWeight: FontWeight.w600,
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
  }

  Widget _buildErrorState(String error) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Center(
      child: Transform.translate(
        offset: Offset(0, -_floatAnimation.value * 0.5),
        child: Container(
          margin: EdgeInsets.all(isDesktop ? 40 : 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDesktop ? 32 : 24),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: EdgeInsets.all(isDesktop ? 48 : 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.9),
                      Colors.white.withValues(alpha: 0.7),
                      AppColors.error.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.error.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: -5,
                      offset: const Offset(0, 20),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 40,
                      spreadRadius: -10,
                      offset: const Offset(0, 25),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 32 : 24),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        LucideIcons.circle_x,
                        size: isDesktop ? 80 : 64,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 32 : 24),
                    Text(
                      'Oops! Something went wrong',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h1.copyWith(
                        fontSize: isDesktop ? 28 : (isTablet ? 24 : 20),
                        fontWeight: FontWeight.w800,
                        color: AppColors.error,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 16 : 8),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        fontSize: isDesktop ? 16 : 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 32 : 24),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE91E63), Color(0xFFFF6B9D)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFE91E63,
                            ).withValues(alpha: 0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            ref
                                .read(collegeViewModelProvider.notifier)
                                .fetchColleges();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 32 : 24,
                              vertical: isDesktop ? 16 : 12,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  LucideIcons.refresh_cw,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: isDesktop ? 12 : 8),
                                Text(
                                  'Try Again',
                                  style: AppTextStyles.body.copyWith(
                                    fontSize: isDesktop ? 18 : 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
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
  }

  Widget _buildCollegesList(List colleges) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      itemCount: colleges.length,
      itemBuilder: (context, index) {
        final college = colleges[index];
        return _buildCollegeCard(college, index);
      },
    );
  }

  Widget _buildCollegeCard(dynamic college, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Transform.translate(
      offset: Offset(
        0,
        -_floatAnimation.value * 0.3 * (index % 2 == 0 ? 1 : -1),
      ),
      child: Container(
        margin: EdgeInsets.only(
          bottom: isDesktop ? 24 : 16,
          left: isDesktop ? 8 : 4,
          right: isDesktop ? 8 : 4,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isDesktop ? 28 : 20),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.9),
                    Colors.white.withValues(alpha: 0.8),
                    const Color(0xFFFFE4E8).withValues(alpha: 0.7),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(isDesktop ? 28 : 20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withValues(alpha: 0.15),
                    blurRadius: 30,
                    spreadRadius: -5,
                    offset: const Offset(0, 20),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 40,
                    spreadRadius: -10,
                    offset: const Offset(0, 25),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(isDesktop ? 24 : 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFE91E63), // College card pink
                          Color(0xFFFF6B9D), // College card light pink
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isDesktop ? 28 : 20),
                        topRight: Radius.circular(isDesktop ? 28 : 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE91E63).withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isDesktop ? 16 : 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            LucideIcons.graduation_cap,
                            color: Colors.white,
                            size: isDesktop ? 28 : 24,
                          ),
                        ),
                        SizedBox(width: isDesktop ? 20 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                college.collegeName,
                                style: AppTextStyles.h2.copyWith(
                                  fontSize: isDesktop
                                      ? 20
                                      : (isTablet ? 18 : 17),
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: isDesktop ? 12 : 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      LucideIcons.map_pin,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${college.district}, ${college.state}',
                                      style: AppTextStyles.body.copyWith(
                                        fontSize: isDesktop ? 15 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withValues(
                                          alpha: 0.95,
                                        ),
                                        height: 1.2,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                            offset: const Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(isDesktop ? 24 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Facilities section
                        if (college.facilities.isNotEmpty) ...[
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(isDesktop ? 12 : 10),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE91E63),
                                      Color(0xFFFF6B9D),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFE91E63,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  LucideIcons.building_2,
                                  color: Colors.white,
                                  size: isDesktop ? 20 : 18,
                                ),
                              ),
                              SizedBox(width: isDesktop ? 16 : 12),
                              Expanded(
                                child: Text(
                                  'Facilities',
                                  style: AppTextStyles.h2.copyWith(
                                    fontSize: isDesktop ? 18 : 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFE91E63),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isDesktop ? 20 : 16),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(isDesktop ? 20 : 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(
                                    0xFFFFE4E8,
                                  ).withValues(alpha: 0.6),
                                  const Color(
                                    0xFFFFCDD2,
                                  ).withValues(alpha: 0.4),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                isDesktop ? 16 : 12,
                              ),
                              border: Border.all(
                                color: const Color(
                                  0xFFE91E63,
                                ).withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFE91E63,
                                  ).withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Wrap(
                              spacing: isDesktop ? 12 : 10,
                              runSpacing: isDesktop ? 12 : 10,
                              children: college.facilities
                                  .map<Widget>(
                                    (facility) => Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isDesktop ? 16 : 12,
                                        vertical: isDesktop ? 8 : 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFE91E63,
                                        ).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(
                                            0xFFE91E63,
                                          ).withValues(alpha: 0.4),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        facility,
                                        style: AppTextStyles.small.copyWith(
                                          fontSize: isDesktop ? 14 : 13,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFE91E63),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: isDesktop ? 24 : 20),
                        ],

                        // Degrees section
                        if (college.degrees.isNotEmpty) ...[
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(isDesktop ? 12 : 10),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF9C27B0),
                                      Color(0xFFBA68C8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF9C27B0,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  LucideIcons.award,
                                  color: Colors.white,
                                  size: isDesktop ? 20 : 18,
                                ),
                              ),
                              SizedBox(width: isDesktop ? 16 : 12),
                              Expanded(
                                child: Text(
                                  'Degrees Offered',
                                  style: AppTextStyles.h2.copyWith(
                                    fontSize: isDesktop ? 18 : 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF9C27B0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isDesktop ? 20 : 16),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(isDesktop ? 20 : 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(
                                    0xFFF3E5F5,
                                  ).withValues(alpha: 0.6),
                                  const Color(
                                    0xFFE1BEE7,
                                  ).withValues(alpha: 0.4),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                isDesktop ? 16 : 12,
                              ),
                              border: Border.all(
                                color: const Color(
                                  0xFF9C27B0,
                                ).withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF9C27B0,
                                  ).withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Wrap(
                              spacing: isDesktop ? 12 : 10,
                              runSpacing: isDesktop ? 12 : 10,
                              children: college.degrees
                                  .map<Widget>(
                                    (degree) => Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isDesktop ? 16 : 14,
                                        vertical: isDesktop ? 10 : 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF9C27B0,
                                        ).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: const Color(
                                            0xFF9C27B0,
                                          ).withValues(alpha: 0.4),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        degree.degreeName,
                                        style: AppTextStyles.small.copyWith(
                                          fontSize: isDesktop ? 14 : 13,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF9C27B0),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(
                      isDesktop ? 24 : 20,
                      isDesktop ? 16 : 8,
                      isDesktop ? 24 : 20,
                      isDesktop ? 24 : 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.3),
                          const Color(0xFFFFE4E8).withValues(alpha: 0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(isDesktop ? 28 : 20),
                        bottomRight: Radius.circular(isDesktop ? 28 : 20),
                      ),
                    ),
                    child: Row(
                      children: [
                        // View Details button
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE91E63), Color(0xFFFF6B9D)],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFE91E63,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  // Add view details functionality
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isDesktop ? 24 : 16,
                                    vertical: isDesktop ? 16 : 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        LucideIcons.eye,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: isDesktop ? 12 : 8),
                                      Text(
                                        'View Details',
                                        style: AppTextStyles.body.copyWith(
                                          fontSize: isDesktop ? 16 : 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: isDesktop ? 16 : 12),

                        // Bookmark button
                        Container(
                          width: isDesktop ? 56 : 48,
                          height: isDesktop ? 56 : 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.8),
                                const Color(0xFFFFE4E8).withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: const Color(
                                0xFFE91E63,
                              ).withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFE91E63,
                                ).withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: () {
                                // Add bookmark functionality
                              },
                              child: const Icon(
                                LucideIcons.bookmark,
                                color: Color(0xFFE91E63),
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
