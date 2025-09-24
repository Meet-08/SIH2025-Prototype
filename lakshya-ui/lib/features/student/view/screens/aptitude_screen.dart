import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakshya/core/constants/mock_data.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/utils/show_snackbar.dart';
import 'package:lakshya/features/student/models/question_model.dart';
import 'package:lakshya/features/student/models/recommended_result_model.dart';
import 'package:lakshya/features/student/view/widgets/widgets.dart';
import 'package:lakshya/features/student/viewmodel/quiz_view_model.dart';

class AptitudeScreen extends ConsumerStatefulWidget {
  const AptitudeScreen({super.key});

  @override
  ConsumerState<AptitudeScreen> createState() => _AptitudeScreenState();
}

class _AptitudeScreenState extends ConsumerState<AptitudeScreen> {
  int currentQuestionIndex = 0;
  Map<int, int> answers = {};

  // Aptitude feature brand colors (match FeatureCard on Home)
  static const Color _accentStart = Color(0xFF00CEC9);
  static const Color _accentEnd = Color(0xFF4ADEAA);
  static const LinearGradient _aptitudeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_accentStart, _accentEnd],
  );

  void _moveNextOrFinish() async {
    if (currentQuestionIndex + 1 < aptitudeQuestions.length) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      await ref
          .read(quizViewModelProvider.notifier)
          .fetchRecommendations(answers);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = aptitudeQuestions[currentQuestionIndex];
    int totalQuestions = aptitudeQuestions.length;
    int answeredCount = answers.length;
    double progressValue = answeredCount / totalQuestions;

    ref.listen<AsyncValue<RecommendationResultModel>?>(quizViewModelProvider, (
      previous,
      next,
    ) {
      next?.when(
        data: (recommendationResult) {
          context.pushNamedAndRemoveUntil('/aptitude-result', (_) => false);
        },
        loading: () {},
        error: (err, stack) {
          showSnackbar(context, 'Error: $err');
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            // Use the aptitude card gradient instead of primary
            gradient: _aptitudeGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        title: const Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.brain, color: Colors.white, size: 28),
            Expanded(
              child: Text(
                'Aptitude Assessment',
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
        // Soft airy background similar to home, tinted towards aptitude teal
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0F7FA), // light cyan
              Color(0xFFE8FFF8), // soft mint
              AppColors.background,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 360;
              final padding = isSmallScreen ? 12.0 : 20.0;

              return Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    // Progress Section
                    _buildProgressSection(
                      progressValue,
                      answeredCount,
                      totalQuestions,
                    ),

                    const SizedBox(height: 16),

                    // Question Card wrapped in glassmorphism container to match home
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(alpha: 0.18),
                                  Colors.white.withValues(alpha: 0.08),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                                BoxShadow(
                                  color: _accentStart.withValues(alpha: 0.12),
                                  blurRadius: 28,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: QuestionCardWidget(
                              question: question,
                              currentQuestionIndex: currentQuestionIndex,
                              accentColor: _accentStart,
                              accentGradient: _aptitudeGradient,
                              child:
                                  question.type == QuestionType.multipleChoice
                                  ? MultipleChoiceOptionsWidget(
                                      question: question,
                                      onOptionSelected: (index) {
                                        setState(() {
                                          answers[currentQuestionIndex] = index;
                                          _moveNextOrFinish();
                                        });
                                      },
                                    )
                                  : SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: RatingQuestionWidget(
                                        selectedRating:
                                            answers[currentQuestionIndex] ?? 0,
                                        onRatingSelected: (rating) {
                                          setState(() {
                                            answers[currentQuestionIndex] =
                                                rating;
                                          });
                                        },
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Navigation Button (for rating questions)
                    if (question.type == QuestionType.rating)
                      _buildNavigationButton(),
                  ],
                ),
              );
            },
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.18),
                Colors.white.withValues(alpha: 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: _accentEnd.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 10),
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
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.7),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      LucideIcons.target,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Progress Tracker",
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                      fontWeight: FontWeight.w700,
                      color: _accentStart,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressValue,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(_accentEnd),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton() {
    final selectedRating = answers[currentQuestionIndex] ?? 0;
    final bool enabled = selectedRating > 0;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? _aptitudeGradient
              : const LinearGradient(
                  colors: [AppColors.textTertiary, AppColors.textTertiary],
                ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (enabled)
              BoxShadow(
                color: _accentStart.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: ElevatedButton(
          onPressed: enabled
              ? () {
                  _moveNextOrFinish();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentQuestionIndex + 1 < aptitudeQuestions.length
                    ? "Next Question"
                    : "Finish Assessment",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
      ),
    );
  }
}
