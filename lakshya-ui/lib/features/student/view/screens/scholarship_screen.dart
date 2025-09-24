import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/theme/app_text_styles.dart';
import 'package:lakshya/features/student/viewmodel/scholarship_view_model.dart';

class ScholarshipScreen extends ConsumerStatefulWidget {
  const ScholarshipScreen({super.key});

  @override
  ConsumerState<ScholarshipScreen> createState() => _ScholarshipScreenState();
}

class _ScholarshipScreenState extends ConsumerState<ScholarshipScreen>
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
      ref.read(scholarshipViewModelProvider.notifier).fetchScholarships();
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
                Color(0xFF7B1FA2), // Darker purple
                Color(0xFF9C27B0), // Main purple
                Color(0xFFBA68C8), // Light purple
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
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
            const Icon(
              LucideIcons.graduation_cap,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Scholarships',
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
              icon: const Icon(LucideIcons.search, color: Colors.white),
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
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Consumer(
                  builder: (context, ref, child) {
                    final scholarshipAsyncValue = ref.watch(
                      scholarshipViewModelProvider,
                    );
                    return scholarshipAsyncValue?.when(
                          data: (scholarshipList) {
                            if (scholarshipList.isEmpty) {
                              return _buildEmptyState();
                            }
                            return _buildScholarshipsList(scholarshipList);
                          },
                          loading: () => _buildLoadingState(),
                          error: (error, stackTrace) =>
                              _buildErrorState(error.toString()),
                        ) ??
                        _buildLoadingState();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final screenWidth = MediaQuery.of(context).size.width;
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
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
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
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        LucideIcons.graduation_cap,
                        size: isDesktop ? 56 : 48,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 32 : 24),
                    Text(
                      'No scholarships available',
                      style: AppTextStyles.h1.copyWith(
                        fontSize: isDesktop ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isDesktop ? 16 : 12),
                    Text(
                      'Check back later for new opportunities',
                      style: AppTextStyles.body.copyWith(
                        fontSize: isDesktop ? 18 : 16,
                        color: const Color(0xFF64748B),
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

  Widget _buildLoadingState() {
    final screenWidth = MediaQuery.of(context).size.width;
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
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const GFLoader(
                      type: GFLoaderType.ios,
                      loaderColorOne: Color(0xFF3B82F6),
                      loaderColorTwo: Color(0xFF10B981),
                      loaderColorThree: Color(0xFF6D28D9),
                      size: GFSize.LARGE,
                    ),
                    SizedBox(height: isDesktop ? 32 : 24),
                    Text(
                      'Loading scholarships...',
                      style: AppTextStyles.body.copyWith(
                        fontSize: isDesktop ? 18 : 16,
                        color: const Color(0xFF64748B),
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
                      Colors.white.withValues(alpha: 0.25),
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
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
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFEF4444,
                            ).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        LucideIcons.circle_x,
                        size: isDesktop ? 56 : 48,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 32 : 24),
                    Text(
                      'Oops! Something went wrong',
                      style: AppTextStyles.h1.copyWith(
                        fontSize: isDesktop ? 24 : 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isDesktop ? 16 : 12),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        fontSize: isDesktop ? 16 : 14,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: isDesktop ? 32 : 24),
                    GFButton(
                      onPressed: () {
                        ref
                            .read(scholarshipViewModelProvider.notifier)
                            .fetchScholarships();
                      },
                      text: 'Try Again',
                      icon: const Icon(
                        LucideIcons.refresh_cw,
                        color: Colors.white,
                        size: 18,
                      ),
                      color: const Color(0xFF3B82F6),
                      shape: GFButtonShape.pills,
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

  Widget _buildScholarshipsList(List scholarshipList) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      itemCount: scholarshipList.length,
      itemBuilder: (context, index) {
        final scholarship = scholarshipList[index];
        return _buildScholarshipCard(scholarship, index);
      },
    );
  }

  Widget _buildScholarshipCard(dynamic scholarship, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF9C27B0), // Deep purple
                    Color(0xFFBA68C8), // Light purple
                    Color(0xFFCE93D8), // Even lighter purple
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with scholarship name and amount
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF7B1FA2), // Darker purple for header
                          Color(0xFF9C27B0), // Main purple
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            LucideIcons.graduation_cap,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scholarship.scholarshipName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${scholarship.amount.toStringAsFixed(2)} INR',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Duration section
                        _buildInfoRow(
                          LucideIcons.calendar,
                          'Duration',
                          '${scholarship.startingDate} to ${scholarship.endingDate}',
                          const Color(0xFF9C27B0),
                        ),
                        const SizedBox(height: 16),

                        // Eligibility section
                        _buildInfoSection(
                          LucideIcons.check,
                          'Eligibility',
                          scholarship.eligibility,
                          const Color(0xFF7B1FA2),
                        ),
                        const SizedBox(height: 16),

                        // Required Documents section
                        _buildInfoSection(
                          LucideIcons.file_text,
                          'Required Documents',
                          scholarship.requiredDocuments,
                          const Color(0xFFBA68C8),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GFButton(
                            onPressed: () {
                              // Add apply functionality
                            },
                            text: 'Apply Now',
                            icon: const Icon(
                              LucideIcons.external_link,
                              color: Colors.white,
                              size: 18,
                            ),
                            color: const Color(0xFF9C27B0),
                            shape: GFButtonShape.pills,
                            size: GFSize.SMALL,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GFIconButton(
                          onPressed: () {
                            // Add bookmark functionality
                          },
                          icon: const Icon(
                            LucideIcons.bookmark,
                            color: Color(0xFF9C27B0),
                            size: 20,
                          ),
                          color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                          shape: GFIconButtonShape.circle,
                          size: GFSize.SMALL,
                        ),
                        const SizedBox(width: 8),
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

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value,
    Color iconColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(
    IconData icon,
    String title,
    List<dynamic> items,
    Color iconColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                item.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
