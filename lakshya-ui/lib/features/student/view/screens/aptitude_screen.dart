import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lakshya/core/constants/mock_data.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/utils/generate_recommendation.dart';
import 'package:lakshya/features/student/models/question_model.dart';
import 'package:lakshya/features/student/view/screens/result_screen.dart';
import 'package:lakshya/features/student/view/widgets/widgets.dart';

class AptitudeScreen extends StatefulWidget {
  const AptitudeScreen({super.key});

  @override
  State<AptitudeScreen> createState() => _AptitudeScreenState();
}

class _AptitudeScreenState extends State<AptitudeScreen> {
  int currentQuestionIndex = 0;
  Map<int, dynamic> answers = {};

  @override
  Widget build(BuildContext context) {
    final question = aptitudeQuestions[currentQuestionIndex];
    int totalQuestions = aptitudeQuestions.length;
    int answeredCount = answers.length;
    double progressValue = answeredCount / totalQuestions;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.brain, size: 24),
            const SizedBox(width: 8),
            Text(
              "Aptitude Assessment",
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
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
              AppColors.primary.withValues(alpha: 0.05),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Progress Section
                _buildProgressSection(
                  progressValue,
                  answeredCount,
                  totalQuestions,
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: QuestionCardWidget(
                    question: question,
                    currentQuestionIndex: currentQuestionIndex,
                    child: question.type == QuestionType.multipleChoice
                        ? MultipleChoiceOptionsWidget(
                            question: question,
                            onOptionSelected: (index) {
                              setState(() {
                                answers[currentQuestionIndex] = index;
                                _moveNextOrFinish();
                              });
                            },
                          )
                        : RatingQuestionWidget(
                            selectedRating: answers[currentQuestionIndex] ?? 0,
                            onRatingSelected: (rating) {
                              setState(() {
                                answers[currentQuestionIndex] = rating;
                              });
                            },
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Navigation Button (for rating questions)
                if (question.type == QuestionType.rating)
                  _buildNavigationButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(
    double progressValue,
    int answeredCount,
    int totalQuestions,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  LucideIcons.target,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Progress Tracker",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$answeredCount of $totalQuestions completed",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                "${(progressValue * 100).toInt()}%",
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 8,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton() {
    final selectedRating = answers[currentQuestionIndex] ?? 0;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedRating > 0
            ? () {
                _moveNextOrFinish();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedRating > 0
              ? AppColors.primary
              : AppColors.textTertiary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: selectedRating > 0 ? 4 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentQuestionIndex + 1 < aptitudeQuestions.length
                  ? "Next Question"
                  : "Finish Assessment",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Icon(
              currentQuestionIndex + 1 < aptitudeQuestions.length
                  ? LucideIcons.arrow_right
                  : LucideIcons.check,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _moveNextOrFinish() {
    if (currentQuestionIndex + 1 < aptitudeQuestions.length) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      final recommendedResult = calculateRecommendation(answers);
      context.push(
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(recommendationResult: recommendedResult),
        ),
      );
    }
  }
}
