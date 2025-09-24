import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakshya/core/constants/mock_data.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/theme/app_text_styles.dart';
import 'package:lakshya/features/student/view/widgets/timeline_widgets.dart';
import 'package:lakshya/features/student/viewmodel/timeline_view_model.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _headerController;
  late Animation<double> _backgroundAnimation;

  TimelineFilter _selectedFilter = TimelineFilter.all;
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

    // Header entrance animation
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Start animations
    _backgroundController.repeat(reverse: true);
    _headerController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _headerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Small helper widget for soft gradient blobs
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;
    final horizontalPadding = isDesktop ? 40.0 : (isTablet ? 30.0 : 20.0);

    // Get filtered events and counts using Riverpod providers
    final filteredEvents = ref.watch(
      filteredTimelineEventsProvider(_selectedFilter),
    );
    final eventCounts = ref.watch(timelineEventCountsProvider);

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
                Color(0xFF3F51B5), // Indigo color
                Color(0xFF5C6BC0), // Lighter indigo color
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3F51B5).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.arrow_left,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Timeline',
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
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              // Base gradient
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                        const Color(0xFF3F51B5).withValues(alpha: 0.10),
                        const Color(0xFF5C6BC0).withValues(alpha: 0.10),
                        _backgroundAnimation.value,
                      )!,
                      Color.lerp(
                        const Color(0xFF3F51B5).withValues(alpha: 0.06),
                        const Color(0xFF5C6BC0).withValues(alpha: 0.06),
                        _backgroundAnimation.value,
                      )!,
                      Color.lerp(
                        const Color(0xFF3F51B5).withValues(alpha: 0.03),
                        const Color(0xFF5C6BC0).withValues(alpha: 0.03),
                        _backgroundAnimation.value,
                      )!,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              // Floating gradient blobs
              Positioned(
                top: 80 - (10 * _backgroundAnimation.value),
                left: -60 + (20 * _backgroundAnimation.value),
                child: _gradientBlob(
                  size: 220,
                  colors: const [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
                  opacity: 0.12,
                ),
              ),
              Positioned(
                bottom: 120 + (12 * _backgroundAnimation.value),
                right: -50 + (15 * _backgroundAnimation.value),
                child: _gradientBlob(
                  size: 180,
                  colors: const [Color(0xFF5C6BC0), Color(0xFF3F51B5)],
                  opacity: 0.10,
                ),
              ),
              // Content
              SafeArea(
                child: Column(
                  children: [
                    // Stats Card
                    TimelineStatsCard(counts: eventCounts),

                    // Filter Chips
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 56,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        children: [
                          const SizedBox(width: 4),
                          _buildFilterChip('All', TimelineFilter.all),
                          const SizedBox(width: 12),
                          _buildFilterChip('Active', TimelineFilter.active),
                          const SizedBox(width: 12),
                          _buildFilterChip('Upcoming', TimelineFilter.upcoming),
                          const SizedBox(width: 12),
                          _buildFilterChip(
                            'Completed',
                            TimelineFilter.completed,
                          ),
                          const SizedBox(width: 12),
                          _buildFilterChip(
                            'Admissions',
                            TimelineFilter.admissions,
                          ),
                          const SizedBox(width: 12),
                          _buildFilterChip(
                            'Scholarships',
                            TimelineFilter.scholarships,
                          ),
                          const SizedBox(width: 12),
                          _buildFilterChip('Exams', TimelineFilter.exams),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Timeline Events List
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await ref
                                .read(timelineViewModelProvider.notifier)
                                .refresh();
                          },
                          child: filteredEvents.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  controller: _scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: filteredEvents.length,
                                  itemBuilder: (context, index) {
                                    final event = filteredEvents[index];
                                    return TimelineEventCard(
                                      event: event,
                                      isFirst: index == 0,
                                      isLast:
                                          index == filteredEvents.length - 1,
                                      onTap: () => _handleEventTap(event),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Scroll to top button
          FloatingActionButton(
            heroTag: "scroll_top",
            mini: true,
            backgroundColor: const Color(0xFF3F51B5),
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            },
            child: const Icon(LucideIcons.arrow_up, color: Colors.white),
          ),
          const SizedBox(height: 12),
          // Help button
          FloatingActionButton(
            heroTag: "help",
            backgroundColor: const Color(0xFF5C6BC0),
            onPressed: _showHelpDialog,
            child: const Icon(Icons.help_outline, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, TimelineFilter filter) {
    return TimelineFilterChip(
      label: label,
      isSelected: _selectedFilter == filter,
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      color: _getFilterColor(filter),
    );
  }

  Color _getFilterColor(TimelineFilter filter) {
    switch (filter) {
      case TimelineFilter.active:
        return const Color(0xFF5C6BC0);
      case TimelineFilter.upcoming:
        return const Color(0xFF3F51B5);
      case TimelineFilter.completed:
        return AppColors.timelinePast;
      case TimelineFilter.admissions:
        return const Color(0xFF3F51B5);
      case TimelineFilter.scholarships:
        return AppColors.secondary;
      case TimelineFilter.exams:
        return AppColors.accent;
      case TimelineFilter.all:
        return const Color(0xFF3F51B5);
    }
  }

  void _handleEventTap(TimelineEvent event) {
    if (event.actionUrl != null) {
      // In a real app, you would launch the URL
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening: ${event.actionUrl}'),
          backgroundColor: const Color(0xFF5C6BC0),
        ),
      );
    } else {
      // Show event details
      _showEventDetails(event);
    }
  }

  void _showEventDetails(TimelineEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (event.location != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.map_pin,
                            size: 16,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
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
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.timelineUpcoming.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.calendar,
              size: 60,
              color: AppColors.timelineUpcoming,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No events found',
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filter or check back later',
            style: AppTextStyles.small.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: AppGradients.timelineGradient,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Timeline Help',
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHelpItem(
                      LucideIcons.zap,
                      'Active Events',
                      'Events that are currently happening or require immediate attention',
                    ),
                    _buildHelpItem(
                      LucideIcons.clock,
                      'Upcoming Events',
                      'Future events that you need to prepare for',
                    ),
                    _buildHelpItem(
                      LucideIcons.check,
                      'Completed Events',
                      'Past events that have already concluded',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.timelineActive,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Got it!',
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.timelineUpcoming.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.timelineUpcoming, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.small.copyWith(
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
