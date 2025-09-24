import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/theme/app_text_styles.dart';
import 'package:lakshya/core/utils/show_snackbar.dart';
import 'package:lakshya/features/student/view/widgets/result_action_button.dart';
import 'package:lakshya/features/student/viewmodel/quiz_view_model.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );

  late AnimationController _backgroundController;
  late AnimationController _floatController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _floatAnimation;

  late final Animation<double> _fadeAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

  late final Animation<Offset> _slideAnimation =
      Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutBack,
        ),
      );

  // Result screen specific gradient colors - Cyan theme
  static const Color _resultStart = Color(0xFF00BCD4); // Cyan
  static const Color _resultEnd = Color(0xFF4DD0E1); // Light cyan
  static const LinearGradient _resultGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_resultStart, _resultEnd],
  );

  @override
  void initState() {
    super.initState();

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
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
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _backgroundController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(quizViewModelProvider)!.value;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Scaffold(
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
                    _resultStart.withValues(alpha: 0.08),
                    _resultEnd.withValues(alpha: 0.06),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    _resultEnd.withValues(alpha: 0.04),
                    _resultStart.withValues(alpha: 0.03),
                    _backgroundAnimation.value,
                  )!,
                  AppColors.background,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: result == null
                ? _buildLoadingState(isDesktop, isTablet)
                : CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        floating: true,
                        snap: true,
                        expandedHeight: 80,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: _resultGradient,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _resultStart.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                          ),
                          title: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.award,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Assessment Results',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          centerTitle: true,
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(isDesktop ? 24 : 16.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Transform.translate(
                              offset: Offset(0, -_floatAnimation.value * 0.3),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: SlideTransition(
                                  position: _slideAnimation,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Success Header Card
                                      _buildSuccessHeader(isDesktop, isTablet),
                                      SizedBox(height: isDesktop ? 32 : 24),

                                      // Recommended Career Card
                                      _buildRecommendedCareerCard(
                                        result.recommendedStream,
                                        isDesktop,
                                        isTablet,
                                      ),
                                      SizedBox(height: isDesktop ? 32 : 24),

                                      // AI Reasoning Card
                                      _buildAIReasoningCard(
                                        result.aiReasoning,
                                        isDesktop,
                                        isTablet,
                                      ),
                                      SizedBox(height: isDesktop ? 40 : 32),

                                      // Action Options
                                      _buildActionOptions(
                                        context,
                                        isDesktop,
                                        isTablet,
                                      ),
                                      SizedBox(height: isDesktop ? 32 : 24),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(bool isDesktop, bool isTablet) {
    return Center(
      child: Transform.translate(
        offset: Offset(0, -_floatAnimation.value * 0.5),
        child: Container(
          margin: EdgeInsets.all(isDesktop ? 40 : 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDesktop ? 32 : 24),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: EdgeInsets.all(isDesktop ? 48 : 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(isDesktop ? 32 : 24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _resultStart.withValues(alpha: 0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 20 : 16),
                      decoration: BoxDecoration(
                        gradient: _resultGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _resultStart.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const GFLoader(
                        type: GFLoaderType.circle,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 24 : 16),
                    Text(
                      'Analyzing Results',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 12 : 8),
                    Text(
                      'Processing your assessment data\nand generating personalized recommendations...',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _buildSuccessHeader(bool isDesktop, bool isTablet) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isDesktop ? 28 : 20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isDesktop ? 32 : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _resultStart.withValues(alpha: 0.95),
                _resultEnd.withValues(alpha: 0.9),
                const Color(
                  0xFF26C6DA,
                ).withValues(alpha: 0.85), // Light cyan blend
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.circular(isDesktop ? 28 : 20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _resultStart.withValues(alpha: 0.3),
                blurRadius: 25,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, -5),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(isDesktop ? 20 : 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  LucideIcons.check,
                  color: Colors.white,
                  size: isDesktop ? 56 : 48,
                ),
              ),
              SizedBox(height: isDesktop ? 24 : 16),
              Text(
                'Assessment Complete!',
                style: AppTextStyles.h1.copyWith(
                  color: Colors.white,
                  fontSize: isDesktop ? 28 : (isTablet ? 26 : 22),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isDesktop ? 12 : 8),
              Text(
                'Your personalized career recommendations are ready',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: isDesktop ? 18 : 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedCareerCard(
    String recommendedStream,
    bool isDesktop,
    bool isTablet,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isDesktop ? 28 : 20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isDesktop ? 28 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(isDesktop ? 28 : 20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _resultStart.withValues(alpha: 0.15),
                blurRadius: 25,
                offset: const Offset(0, 10),
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
                    padding: EdgeInsets.all(isDesktop ? 16 : 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _resultStart.withValues(alpha: 0.3),
                          _resultEnd.withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
                      boxShadow: [
                        BoxShadow(
                          color: _resultStart.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.award,
                      color: _resultStart,
                      size: isDesktop ? 28 : 24,
                    ),
                  ),
                  SizedBox(width: isDesktop ? 20 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommended Career Path',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: isDesktop ? 20 : (isTablet ? 19 : 18),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: isDesktop ? 6 : 4),
                        Text(
                          'Based on your interests and aptitude',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isDesktop ? 15 : 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isDesktop ? 24 : 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isDesktop ? 20 : 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(
                        0xFFB2EBF2,
                      ).withValues(alpha: 0.8), // Cyan container
                      const Color(
                        0xFFE0F7FA,
                      ).withValues(alpha: 0.6), // Light cyan container
                    ],
                  ),
                  borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
                  border: Border.all(
                    color: _resultStart.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _resultStart.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  recommendedStream,
                  style: AppTextStyles.h1.copyWith(
                    color: const Color(0xFF006064), // Dark cyan for text
                    fontSize: isDesktop ? 26 : (isTablet ? 24 : 22),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIReasoningCard(
    String aiReasoning,
    bool isDesktop,
    bool isTablet,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(isDesktop ? 28 : 20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isDesktop ? 28 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(isDesktop ? 28 : 20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00ACC1).withValues(alpha: 0.15),
                blurRadius: 25,
                offset: const Offset(0, 10),
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
                    padding: EdgeInsets.all(isDesktop ? 16 : 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(
                            0xFF18FFFF,
                          ).withValues(alpha: 0.3), // Bright cyan accent
                          const Color(
                            0xFF84FFFF,
                          ).withValues(alpha: 0.2), // Light cyan accent
                        ],
                      ),
                      borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00ACC1).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.lightbulb,
                      color: const Color(0xFF00ACC1), // Cyan accent for icon
                      size: isDesktop ? 28 : 24,
                    ),
                  ),
                  SizedBox(width: isDesktop ? 20 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Analysis & Insights',
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: isDesktop ? 20 : (isTablet ? 19 : 18),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: isDesktop ? 6 : 4),
                        Text(
                          'Detailed reasoning behind your recommendation',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: isDesktop ? 15 : 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isDesktop ? 24 : 20),
              Container(
                padding: EdgeInsets.all(isDesktop ? 20 : 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.surface.withValues(alpha: 0.8),
                      AppColors.surface.withValues(alpha: 0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
                  border: Border.all(
                    color: AppColors.outline.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00ACC1).withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: GptMarkdown(aiReasoning),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionOptions(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s Next?',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.textPrimary,
            fontSize: isDesktop ? 28 : (isTablet ? 26 : 22),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isDesktop ? 20 : 16),
        Row(
          children: [
            Expanded(
              child: ResultActionButton(
                icon: LucideIcons.search,
                title: 'Dive Deeper',
                subtitle: 'Explore more career options',
                onTap: () {
                  // TODO: Navigate to detailed career exploration
                  showSnackbar(context, 'Feature coming soon!');
                },
                gradient: AppGradients.secondaryGradient,
              ),
            ),
            SizedBox(width: isDesktop ? 20 : 16),
            Expanded(
              child: ResultActionButton(
                icon: LucideIcons.house,
                title: 'Go to Home',
                subtitle: 'Return to dashboard',
                onTap: () {
                  context.pushNamedAndRemoveUntil(
                    '/student-home',
                    (_) => false,
                  );
                },
                gradient: AppGradients.accentGradient,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
