import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lakshya/core/core.dart';

class RatingQuestionWidget extends StatelessWidget {
  final int selectedRating;
  final Function(int) onRatingSelected;

  const RatingQuestionWidget({
    super.key,
    required this.selectedRating,
    required this.onRatingSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Rating Description
        _buildRatingDescription(context),

        const SizedBox(height: 32),

        // Rating Scale
        _buildRatingScale(context),

        const SizedBox(height: 24),

        // Rating Labels
        _buildRatingLabels(context),

        const SizedBox(height: 32),

        // Selected Rating Display
        if (selectedRating > 0) _buildSelectedRatingDisplay(context),
      ],
    );
  }

  Widget _buildRatingDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.info, color: AppColors.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Rate from 1 (Strongly Disagree) to 5 (Strongly Agree)",
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.onAccentContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingScale(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final rating = index + 1;
        final isSelected = selectedRating == rating;

        return GestureDetector(
          onTap: () => onRatingSelected(rating),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.outlineVariant,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.star,
                  color: isSelected
                      ? AppColors.onAccent
                      : AppColors.textSecondary,
                  size: 24,
                ),
                const SizedBox(height: 2),
                Text(
                  rating.toString(),
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? AppColors.onAccent
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRatingLabels(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Disagree",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            "Neutral",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            "Agree",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedRatingDisplay(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.check, color: AppColors.secondary, size: 20),
          const SizedBox(width: 8),
          Text(
            "You selected: $selectedRating",
            style: context.textTheme.titleSmall?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
