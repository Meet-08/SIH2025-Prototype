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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      children: [
        // Rating Description
        _buildRatingDescription(context),

        SizedBox(height: isSmallScreen ? 20 : 32),

        // Rating Scale
        _buildRatingScale(context),

        SizedBox(height: isSmallScreen ? 16 : 24),

        // Rating Labels
        _buildRatingLabels(context),

        SizedBox(height: isSmallScreen ? 20 : 32),
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
    // Make rating buttons responsive based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final buttonSize = isSmallScreen ? 48.0 : 60.0;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final fontSize = isSmallScreen ? 10.0 : 12.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final rating = index + 1;
        final isSelected =
            rating <= selectedRating; // Fill stars up to selected rating

        return Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 2.0 : 4.0,
            ),
            child: GestureDetector(
              onTap: () => onRatingSelected(rating),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accent
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(buttonSize / 2),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.outlineVariant,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
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
                      isSelected ? LucideIcons.star : LucideIcons.star,
                      color: isSelected
                          ? AppColors.onAccent
                          : AppColors.textSecondary,
                      size: iconSize,
                    ),
                    SizedBox(height: isSmallScreen ? 1 : 2),
                    Text(
                      rating.toString(),
                      style: context.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                        color: isSelected
                            ? AppColors.onAccent
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRatingLabels(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final fontSize = isSmallScreen ? 10.0 : 12.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Disagree",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: fontSize,
            ),
          ),
          Text(
            "Neutral",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: fontSize,
            ),
          ),
          Text(
            "Agree",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
