import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lakshya/core/constants/mock_data.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/features/student/view/widgets/career_roadmap_graph.dart';
import 'package:lakshya/features/student/viewmodel/career_map_view_model.dart';

class CourseToCareerMappingScreen extends ConsumerStatefulWidget {
  const CourseToCareerMappingScreen({super.key});

  @override
  ConsumerState<CourseToCareerMappingScreen> createState() =>
      _CourseToCareerMappingScreenState();
}

class _CourseToCareerMappingScreenState
    extends ConsumerState<CourseToCareerMappingScreen> {
  String? _selectedCareerField;
  Key _graphKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _selectedCareerField = careerFields.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(careerMapViewModelProvider.notifier)
          .fetchCareerMap(careerFields.first);
    });
  }

  void _onCareerFieldSelected(String? careerField) {
    if (careerField != null) {
      setState(() {
        _selectedCareerField = careerField;
      });
      ref.read(careerMapViewModelProvider.notifier).fetchCareerMap(careerField);
      _resetGraph();
    }
  }

  void _resetGraph() {
    setState(() {
      _graphKey = UniqueKey();
    });
  }

  void _onGraphReset() {
    // Callback when the graph has been reset
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
            gradient: AppGradients.careerRoadmapGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        title: Row(
          children: [
            GFIconButton(
              onPressed: () => context.pop(),
              icon: const Icon(LucideIcons.arrow_left, color: Colors.white),
              color: Colors.white.withValues(alpha: 0.2),
              shape: GFIconButtonShape.circle,
              size: GFSize.MEDIUM,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Career Roadmap Explorer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              AppColors.parentPrimary.withValues(alpha: 0.05),
              AppColors.background,
              AppColors.background,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.parentPrimary.withValues(
                        alpha: 0.15,
                      ), // Purple tint
                      AppColors.parentSecondary.withValues(
                        alpha: 0.1,
                      ), // Teal accent
                      Colors.white,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.parentPrimary.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.parentPrimary,
                                  AppColors.scientificDomain,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.parentPrimary.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              LucideIcons.target,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Select Your Career Field',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      GFCard(
                        elevation: 4,
                        color: Colors.white,
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        boxFit: BoxFit.cover,
                        content: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.parentPrimary.withValues(
                                alpha: 0.3,
                              ),
                              width: 2,
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                AppColors.parentPrimary.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            child: DropdownButton<String>(
                              value: _selectedCareerField,
                              items: careerFields
                                  .map(
                                    (field) => DropdownMenuItem<String>(
                                      value: field,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: AppColors.parentPrimary
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              LucideIcons.briefcase,
                                              size: 16,
                                              color: AppColors.parentPrimary,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              field,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: _onCareerFieldSelected,
                              hint: const Row(
                                children: [
                                  Icon(
                                    LucideIcons.search,
                                    size: 20,
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Choose a career field...',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              underline: Container(),
                              isExpanded: true,
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.parentPrimary.withValues(
                                        alpha: 0.2,
                                      ),
                                      AppColors.parentPrimary.withValues(
                                        alpha: 0.1,
                                      ),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  LucideIcons.chevron_down,
                                  color: AppColors.parentPrimary,
                                  size: 18,
                                ),
                              ),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.parentAccent.withValues(alpha: 0.2),
                              AppColors.parentSecondary.withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.parentPrimary.withValues(
                              alpha: 0.3,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.parentPrimary,
                                    AppColors.scientificDomain,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                LucideIcons.lightbulb,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Explore interactive career pathways and discover educational opportunities tailored to your interests.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.onPrimaryContainer,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
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
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        AppColors.surface,
                        AppColors.parentPrimary.withValues(alpha: 0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.parentPrimary.withValues(alpha: 0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.parentPrimary.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppColors.parentSecondary.withValues(
                          alpha: 0.08,
                        ),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        // Background pattern
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  AppColors.primaryContainer.withValues(
                                    alpha: 0.03,
                                  ),
                                  Colors.transparent,
                                  AppColors.secondaryContainer.withValues(
                                    alpha: 0.02,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            final careerMapState = ref.watch(
                              careerMapViewModelProvider,
                            );
                            return careerMapState?.when(
                                  data: (careerModel) {
                                    return CareerRoadmapGraph(
                                      key: _graphKey,
                                      careerMapModel: careerModel,
                                      onResetGraph: _onGraphReset,
                                      onShowHelp: () =>
                                          _showHelpDialog(context),
                                    );
                                  },
                                  error: (error, stackTrace) {
                                    return Center(
                                      child: Container(
                                        margin: const EdgeInsets.all(24),
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: AppColors.errorContainer,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: AppColors.error.withValues(
                                              alpha: 0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: AppColors.error,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                LucideIcons.triangle_alert,
                                                size: 32,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Error Loading Career Map',
                                              style: TextStyle(
                                                color:
                                                    AppColors.onErrorContainer,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'We encountered an issue while loading your career roadmap. Please try again.',
                                              style: TextStyle(
                                                color: AppColors
                                                    .onErrorContainer
                                                    .withValues(alpha: 0.8),
                                                fontSize: 14,
                                                height: 1.4,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            GFButton(
                                              onPressed: () => ref
                                                  .read(
                                                    careerMapViewModelProvider
                                                        .notifier,
                                                  )
                                                  .fetchCareerMap(
                                                    _selectedCareerField!,
                                                  ),
                                              text: "Retry",
                                              icon: const Icon(
                                                LucideIcons.refresh_cw,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              color: AppColors.error,
                                              shape: GFButtonShape.standard,
                                              size: GFSize.SMALL,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  loading: () {
                                    return Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    AppColors.primary,
                                                    AppColors.primaryDark,
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.primary
                                                        .withValues(alpha: 0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                LucideIcons.route,
                                                size: 32,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            const GFLoader(
                                              type: GFLoaderType.circle,
                                              loaderColorOne: AppColors.primary,
                                              loaderColorTwo:
                                                  AppColors.secondary,
                                              loaderColorThree:
                                                  AppColors.accent,
                                              size: 40,
                                            ),
                                            const SizedBox(height: 24),
                                            const Text(
                                              'Mapping Your Career Journey',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Please wait while we generate your personalized roadmap...',
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 14,
                                                height: 1.4,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ) ??
                                const Center(
                                  child: GFLoader(
                                    type: GFLoaderType.circle,
                                    loaderColorOne: AppColors.primary,
                                    loaderColorTwo: AppColors.secondary,
                                    loaderColorThree: AppColors.accent,
                                    size: 40,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.parentPrimary, AppColors.scientificDomain],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.parentPrimary.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _resetGraph,
                child: Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    LucideIcons.refresh_cw,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.parentPrimary, AppColors.parentSecondary],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.parentSecondary.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showHelpDialog(context),
                child: Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    LucideIcons.info,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  AppColors.parentPrimary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.parentPrimary.withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.parentPrimary.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.parentPrimary,
                        AppColors.scientificDomain,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          LucideIcons.book_open,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How to Use',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Career Roadmap Guide',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHelpItem(
                          LucideIcons.mouse_pointer_click,
                          'Tap nodes to expand career paths',
                          'Discover educational opportunities and career options by clicking on interactive nodes.',
                        ),
                        _buildHelpItem(
                          LucideIcons.zoom_in,
                          'Pinch to zoom in/out',
                          'Use pinch gestures to get a closer look at specific areas of your roadmap.',
                        ),
                        _buildHelpItem(
                          LucideIcons.move,
                          'Drag to navigate the graph',
                          'Pan around the roadmap by dragging to explore different sections.',
                        ),
                        _buildHelpItem(
                          LucideIcons.refresh_cw,
                          'Use refresh button to reset view',
                          'Return to the starting point and collapse all expanded nodes.',
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GFButton(
                        onPressed: () => Navigator.of(context).pop(),
                        text: "Got it!",
                        icon: const Icon(
                          LucideIcons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                        color: AppColors.parentPrimary,
                        shape: GFButtonShape.standard,
                        size: GFSize.LARGE,
                      ),
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

  Widget _buildHelpItem(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.parentPrimary.withValues(alpha: 0.08),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.parentPrimary.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.parentPrimary.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.parentPrimary, AppColors.scientificDomain],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.parentPrimary.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
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
