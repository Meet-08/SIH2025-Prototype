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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionHeader(context),

          const SizedBox(height: 16),

          _buildQuestionText(context),

          const SizedBox(height: 16),

          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            question.type == QuestionType.multipleChoice
                ? LucideIcons.list_checks
                : LucideIcons.star,
            color: AppColors.primary,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Text(
        question.question,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.4,
        ),
      ),
    );
  }
}
