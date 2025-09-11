import 'package:flutter/material.dart';
import 'package:lakshya/core/extensions/extensions.dart';
import 'package:lakshya/features/student/models/recommended_result_model.dart';
import 'package:lakshya/features/student/view/widgets/domain_bar_chart.dart';

class ResultScreen extends StatelessWidget {
  final RecommendationResult recommendationResult;
  const ResultScreen({super.key, required this.recommendationResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Result", style: context.textTheme.headlineMedium),
              Text(
                "Discover your ideal career path",
                style: context.textTheme.bodyMedium,
              ),

              const SizedBox(height: 20),
              Container(
                height: 460,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "Recommended Career Path: ${recommendationResult.recommendedStream}",
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      "Your aptitude scores across domains(%):",
                      style: context.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    DomainBarChart(
                      domainScores: recommendationResult.domainScores,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
