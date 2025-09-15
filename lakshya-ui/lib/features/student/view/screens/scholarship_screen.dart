import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/features/student/viewmodel/scholarship_view_model.dart';

class ScholarshipScreen extends ConsumerStatefulWidget {
  const ScholarshipScreen({super.key});

  @override
  ConsumerState<ScholarshipScreen> createState() => _ScholarshipScreenState();
}

class _ScholarshipScreenState extends ConsumerState<ScholarshipScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

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
          decoration: const BoxDecoration(
            gradient: AppGradients.scholarshipGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.secondary.withValues(alpha: 0.05),
              AppColors.background,
              AppColors.background,
            ],
            stops: const [0.0, 0.3, 1.0],
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.scholarshipActive.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.graduation_cap,
              size: 64,
              color: AppColors.scholarshipActive,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No scholarships available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check back later for new opportunities',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GFLoader(
            type: GFLoaderType.ios,
            loaderColorOne: AppColors.scholarshipActive,
            loaderColorTwo: AppColors.secondary,
            loaderColorThree: AppColors.accent,
            size: GFSize.LARGE,
          ),
          SizedBox(height: 24),
          Text(
            'Loading scholarships...',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.circle_x,
              size: 64,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
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
            color: AppColors.scholarshipActive,
            shape: GFButtonShape.pills,
          ),
        ],
      ),
    );
  }

  Widget _buildScholarshipsList(List scholarshipList) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: scholarshipList.length,
            itemBuilder: (context, index) {
              final scholarship = scholarshipList[index];
              return _buildScholarshipCard(scholarship, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildScholarshipCard(dynamic scholarship, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GFCard(
        elevation: 4,
        boxFit: BoxFit.cover,
        color: AppColors.surface,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          children: [
            // Header with scholarship name and amount
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.scholarshipActive.withValues(alpha: 0.9),
                    AppColors.secondary.withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
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
              color: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Duration section
                  _buildInfoRow(
                    LucideIcons.calendar,
                    'Duration',
                    '${scholarship.startingDate} to ${scholarship.endingDate}',
                    AppColors.primary,
                  ),
                  const SizedBox(height: 16),

                  // Eligibility section
                  _buildInfoSection(
                    LucideIcons.check,
                    'Eligibility',
                    scholarship.eligibility,
                    AppColors.scholarshipActive,
                  ),
                  const SizedBox(height: 16),

                  // Required Documents section
                  _buildInfoSection(
                    LucideIcons.file_text,
                    'Required Documents',
                    scholarship.requiredDocuments,
                    AppColors.accent,
                  ),
                ],
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
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
                      color: AppColors.scholarshipActive,
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
                      color: AppColors.primary,
                      size: 20,
                    ),
                    color: AppColors.primary.withValues(alpha: 0.1),
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
