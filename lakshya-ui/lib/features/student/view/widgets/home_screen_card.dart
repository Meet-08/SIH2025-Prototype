import 'package:flutter/material.dart';
import 'package:lakshya/core/core.dart';

class HomeScreenCard extends StatelessWidget {
  final String? course;
  const HomeScreenCard({super.key, this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppColors.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Career Roadmap',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your personalized path to success based on your your aptitudes and interests.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            if (course != null) ...[
              const SizedBox(height: 16),
              Text(
                'Recommended Course:',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(course!, style: Theme.of(context).textTheme.bodyMedium),
            ] else ...[
              const SizedBox(height: 16),
              Text(
                'Take the aptitude test to get your personalized course recommendation.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.pushNamed("/aptitude-quiz"),
                child: const Text('Take Aptitude Test'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
