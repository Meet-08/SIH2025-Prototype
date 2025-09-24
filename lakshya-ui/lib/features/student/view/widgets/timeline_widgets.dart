import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:lakshya/core/constants/mock_data.dart';
import 'package:lakshya/core/theme/app_colors.dart';
import 'package:lakshya/core/theme/app_text_styles.dart';

class TimelineEventCard extends StatelessWidget {
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  const TimelineEventCard({
    super.key,
    required this.event,
    this.isFirst = false,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = event.status == TimelineEventStatus.active;
    final isCompleted = event.status == TimelineEventStatus.completed;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator column
          SizedBox(
            width: 60,
            child: Column(
              children: [
                // Top line (except for first item)
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 20,
                    color: _getTimelineColor().withValues(alpha: 0.3),
                  ),

                // Timeline dot
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getTimelineColor(),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: _getTimelineColor().withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 10)
                      : null,
                ),

                // Bottom line (except for last item)
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: _getTimelineColor().withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),

          // Content card (glassmorphism)
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, left: 12),
              child: GestureDetector(
                onTap: onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.14),
                            Colors.white.withValues(alpha: 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getTimelineColor().withValues(alpha: 0.18),
                            spreadRadius: 0,
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with date and type
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.title,
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: _getTimelineColor(),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat(
                                        'dd MMM yyyy',
                                      ).format(event.date),
                                      style: AppTextStyles.small.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getTimelineColor().withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getEventTypeIcon(),
                                      size: 12,
                                      color: _getTimelineColor(),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _getEventTypeLabel(),
                                      style: AppTextStyles.small.copyWith(
                                        color: _getTimelineColor(),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            event.description,
                            style: AppTextStyles.small.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          if (event.location != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  LucideIcons.map_pin,
                                  size: 14,
                                  color: AppColors.textTertiary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    event.location!,
                                    style: AppTextStyles.small.copyWith(
                                      color: AppColors.textTertiary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (event.actionUrl != null && !isCompleted) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _getTimelineColor(),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  isActive ? 'Take Action' : 'Learn More',
                                  style: AppTextStyles.small.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTimelineColor() {
    switch (event.status) {
      case TimelineEventStatus.completed:
        return AppColors.timelinePast;
      case TimelineEventStatus.active:
        return AppColors.timelineActive;
      case TimelineEventStatus.upcoming:
        return AppColors.timelineUpcoming;
    }
  }

  IconData _getEventTypeIcon() {
    switch (event.type) {
      case TimelineEventType.admission:
        return LucideIcons.school;
      case TimelineEventType.scholarship:
        return LucideIcons.dollar_sign;
      case TimelineEventType.exam:
        return LucideIcons.file_text;
      case TimelineEventType.counseling:
        return LucideIcons.users;
      case TimelineEventType.deadline:
        return LucideIcons.clock;
      case TimelineEventType.announcement:
        return LucideIcons.megaphone;
      case TimelineEventType.workshop:
        return LucideIcons.presentation;
      case TimelineEventType.career:
        return LucideIcons.briefcase;
    }
  }

  String _getEventTypeLabel() {
    switch (event.type) {
      case TimelineEventType.admission:
        return 'ADMISSION';
      case TimelineEventType.scholarship:
        return 'SCHOLARSHIP';
      case TimelineEventType.exam:
        return 'EXAM';
      case TimelineEventType.counseling:
        return 'COUNSELING';
      case TimelineEventType.deadline:
        return 'DEADLINE';
      case TimelineEventType.announcement:
        return 'NEWS';
      case TimelineEventType.workshop:
        return 'WORKSHOP';
      case TimelineEventType.career:
        return 'CAREER';
    }
  }
}

class TimelineFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const TimelineFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? chipColor : chipColor.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: chipColor.withValues(alpha: 0.3),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.small.copyWith(
              color: isSelected ? Colors.white : chipColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class TimelineStatsCard extends StatelessWidget {
  final Map<String, int> counts;

  const TimelineStatsCard({super.key, required this.counts});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                // Pure indigo gradient without any white blending
                Color(0xFF3F51B5),
                Color(0xFF5C6BC0),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3F51B5).withValues(alpha: 0.20),
                spreadRadius: 0,
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildStatItem(
                'Active',
                counts['active'] ?? 0,
                LucideIcons.zap,
                Colors.white,
              ),
              const SizedBox(width: 20),
              _buildStatItem(
                'Upcoming',
                counts['upcoming'] ?? 0,
                LucideIcons.clock,
                Colors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 20),
              _buildStatItem(
                'Completed',
                counts['completed'] ?? 0,
                LucideIcons.check,
                Colors.white.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: AppTextStyles.h1.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.small.copyWith(color: color, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
