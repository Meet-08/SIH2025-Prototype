import 'package:flutter/material.dart';
import 'package:lakshya/core/theme/app_colors.dart';

/// Specialized widgets for Lakshya app features
class FeatureWidgets {
  FeatureWidgets._();

  /// Quiz Question Card
  static Widget quizQuestionCard({
    required String question,
    required List<String> options,
    required Function(int) onOptionSelected,
    int? selectedOption,
    bool showResult = false,
    int? correctAnswer,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.quizGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;

              Color getOptionColor() {
                if (!showResult) {
                  return selectedOption == index
                      ? AppColors.accent
                      : Colors.white.withValues(alpha: 0.9);
                }
                if (index == correctAnswer) return AppColors.quizCorrect;
                if (index == selectedOption && index != correctAnswer) {
                  return AppColors.quizIncorrect;
                }
                return Colors.white.withValues(alpha: 0.7);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: showResult ? null : () => onOptionSelected(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: getOptionColor(),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedOption == index || showResult
                                  ? Colors.white
                                  : AppColors.primary,
                              width: 2,
                            ),
                            color:
                                selectedOption == index ||
                                    (showResult && index == correctAnswer)
                                ? Colors.white
                                : Colors.transparent,
                          ),
                          child:
                              selectedOption == index ||
                                  (showResult && index == correctAnswer)
                              ? Icon(
                                  showResult && index == correctAnswer
                                      ? Icons.check
                                      : Icons.circle,
                                  size: 12,
                                  color: getOptionColor(),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              color: selectedOption == index || showResult
                                  ? Colors.white
                                  : AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Interest Domain Card
  static Widget interestDomainCard({
    required String domain,
    required String description,
    required double percentage,
    required Color domainColor,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                domainColor.withValues(alpha: 0.1),
                domainColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: domainColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: domainColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          domain,
                          style: TextStyle(
                            color: domainColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${percentage.toInt()}% Match',
                          style: TextStyle(
                            color: domainColor.withValues(alpha: 0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: domainColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(domainColor),
                minHeight: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Career Roadmap Node
  static Widget careerRoadmapNode({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
    required bool isAccessible,
    VoidCallback? onTap,
  }) {
    Color getNodeColor() {
      if (isCompleted) return AppColors.roadmapCompleted;
      if (isCurrent) return AppColors.roadmapCurrent;
      if (isAccessible) return AppColors.roadmapNode;
      return AppColors.roadmapFuture;
    }

    return InkWell(
      onTap: isAccessible ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: getNodeColor().withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: getNodeColor(), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: getNodeColor(),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted
                    ? Icons.check
                    : isCurrent
                    ? Icons.play_arrow
                    : isAccessible
                    ? Icons.circle
                    : Icons.lock,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: getNodeColor(),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: getNodeColor().withValues(alpha: 0.8),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// College Card
  static Widget collegeCard({
    required String name,
    required String location,
    required double distance,
    required List<String> streams,
    required bool isGovernment,
    required String fees,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isGovernment
                          ? AppColors.collegeGovt.withValues(alpha: 0.1)
                          : AppColors.collegePrivate.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isGovernment ? 'GOVT' : 'PVT',
                      style: TextStyle(
                        color: isGovernment
                            ? AppColors.collegeGovt
                            : AppColors.collegePrivate,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: AppColors.collegeLocation,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '${distance.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.currency_rupee,
                    color: AppColors.collegeFees,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    fees,
                    style: const TextStyle(
                      color: AppColors.collegeFees,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: streams
                    .take(3)
                    .map(
                      (stream) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          stream,
                          style: const TextStyle(
                            color: AppColors.onPrimaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Scholarship Card
  static Widget scholarshipCard({
    required String name,
    required String eligibility,
    required DateTime deadline,
    required String amount,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    final daysLeft = deadline.difference(DateTime.now()).inDays;

    Color getStatusColor() {
      if (!isActive) return AppColors.scholarshipExpired;
      if (daysLeft <= 7) return AppColors.scholarshipExpiring;
      return AppColors.scholarshipActive;
    }

    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: getStatusColor().withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isActive
                          ? daysLeft > 0
                                ? '$daysLeft days left'
                                : 'Expired'
                          : 'Inactive',
                      style: TextStyle(
                        color: getStatusColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                eligibility,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.currency_rupee,
                    color: AppColors.accent,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.calendar_today, color: getStatusColor(), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${deadline.day}/${deadline.month}/${deadline.year}',
                    style: TextStyle(
                      color: getStatusColor(),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Timeline Event Card
  static Widget timelineEventCard({
    required String title,
    required String description,
    required DateTime date,
    required bool isCompleted,
    required bool isUpcoming,
    VoidCallback? onTap,
  }) {
    Color getEventColor() {
      if (isCompleted) return AppColors.timelinePast;
      if (isUpcoming) return AppColors.timelineUpcoming;
      return AppColors.timelineActive;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: getEventColor().withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: getEventColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: getEventColor(),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: getEventColor(),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: TextStyle(
                      color: getEventColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (!isCompleted)
              Icon(
                isUpcoming ? Icons.schedule : Icons.notifications_active,
                color: getEventColor(),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  /// Parent Dashboard Info Card
  static Widget parentInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Language Selector
  static Widget languageSelector({
    required String currentLanguage,
    required List<Map<String, dynamic>> languages,
    required Function(String) onLanguageChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Language / भाषा चुनें',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: languages.map((lang) {
              final isSelected = lang['code'] == currentLanguage;
              return InkWell(
                onTap: () => onLanguageChanged(lang['code']),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? lang['color'].withValues(alpha: 0.2)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? lang['color']
                          : AppColors.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    lang['name'],
                    style: TextStyle(
                      color: isSelected
                          ? lang['color']
                          : AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
