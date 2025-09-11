import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/features/student/models/question_model.dart';

class QuestionCardWidget extends StatelessWidget {
  final QuestionModel question;
  final int currentQuestionIndex;
  final Widget child;

  const QuestionCardWidget({
    super.key,
    required this.question,
    required this.currentQuestionIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Header
          _buildQuestionHeader(context),

          const SizedBox(height: 24),

          // Question Text
          _buildQuestionText(context),

          const SizedBox(height: 24),

          // Answer Options
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            question.type == QuestionType.multipleChoice
                ? LucideIcons.list_checks
                : LucideIcons.star,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Question ${currentQuestionIndex + 1}",
                style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionText(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Text(
        question.question,
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }
}
