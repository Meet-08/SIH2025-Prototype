import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/features/student/models/question_model.dart';

class QuestionCardWidget extends StatelessWidget {
  final QuestionModel question;
  final int currentQuestionIndex;
  final Widget child;
  final Color? accentColor;
  final Gradient? accentGradient;

  const QuestionCardWidget({
    super.key,
    required this.question,
    required this.currentQuestionIndex,
    required this.child,
    this.accentColor,
    this.accentGradient,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = accentColor ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(context),

          const SizedBox(height: 12),

          _buildQuestionText(context),

          const SizedBox(height: 12),

          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(BuildContext context) {
    final Color accent = accentColor ?? AppColors.primary;
    // Build a softer glass-like gradient if a vivid accentGradient is provided
    final Gradient badgeGradient = () {
      if (accentGradient is LinearGradient) {
        final lg = accentGradient as LinearGradient;
        final c0 = lg.colors.isNotEmpty ? lg.colors.first : accent;
        final c1 = lg.colors.length > 1 ? lg.colors.last : accent;
        return LinearGradient(
          begin: lg.begin,
          end: lg.end,
          colors: [c0.withValues(alpha: 0.30), c1.withValues(alpha: 0.15)],
        );
      }
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accent.withValues(alpha: 0.20),
          accent.withValues(alpha: 0.05),
        ],
      );
    }();
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: badgeGradient,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
          ),
          child: Icon(
            question.type == QuestionType.multipleChoice
                ? LucideIcons.list_checks
                : LucideIcons.star,
            // On vivid gradient backgrounds, white icon ensures contrast
            color: accentGradient != null
                ? Colors.white
                : accent.withValues(alpha: 1),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Question ${currentQuestionIndex + 1}",
                style: context.textTheme.titleMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionText(BuildContext context) {
    final Color accent = accentColor ?? AppColors.primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 1),
      ),
      child: Text(
        question.question,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          height: 1.4,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
