import 'package:flutter/material.dart';
import 'package:lakshya/core/constants/mock_data.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/core/utils/generate_recommendation.dart';
import 'package:lakshya/features/student/models/question_model.dart';
import 'package:lakshya/features/student/view/screens/result_screen.dart';

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

    return Scaffold(
      backgroundColor: const Color.fromARGB(148, 248, 249, 250),
      body: SafeArea(
        child: Container(
          height: 550,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Aptitude Test & Interests",
                  style: context.textTheme.headlineMedium,
                ),
              ),

              const SizedBox(height: 12),
              Text(
                "Progress: $answeredCount of $totalQuestions answered",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: answeredCount / totalQuestions,
                borderRadius: BorderRadius.circular(12),
                minHeight: 15,
              ),

              const SizedBox(height: 12),
              Text(
                "Q${currentQuestionIndex + 1}: ${question.question}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              if (question.type == QuestionType.multipleChoice)
                ..._buildMultipleChoiceOptions(question)
              else if (question.type == QuestionType.rating)
                _buildRatingQuestion(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMultipleChoiceOptions(QuestionModel question) {
    return List.generate(
      question.options!.length,
      (index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              answers[currentQuestionIndex] = index;
              _moveNextOrFinish();
            });
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: Text(question.options![index]),
        ),
      ),
    );
  }

  Widget _buildRatingQuestion() {
    final selectedRating = answers[currentQuestionIndex] ?? 0;

    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < selectedRating ? Icons.star : Icons.star_border,
                color: Colors.orange,
                size: 36,
              ),
              onPressed: () {
                setState(() {
                  answers[currentQuestionIndex] = index + 1;
                });
              },
            );
          }),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: selectedRating > 0
              ? () {
                  _moveNextOrFinish();
                }
              : null,
          child: const Text("Next"),
        ),
      ],
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
