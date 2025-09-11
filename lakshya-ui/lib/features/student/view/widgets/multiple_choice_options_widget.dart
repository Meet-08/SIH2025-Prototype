import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lakshya/core/core.dart';
import 'package:lakshya/features/student/models/question_model.dart';

class MultipleChoiceOptionsWidget extends StatelessWidget {
  final QuestionModel question;
  final Function(int) onOptionSelected;

  const MultipleChoiceOptionsWidget({
    super.key,
    required this.question,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.options!.asMap().entries.map((entry) {
        final int index = entry.key;
        final String option = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => onOptionSelected(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getOptionColor(index),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              children: [
                Icon(_getOptionIcon(index), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getOptionIcon(int index) {
    switch (index) {
      case 0:
        return LucideIcons.circle;
      case 1:
        return LucideIcons.square;
      case 2:
        return LucideIcons.triangle;
      case 3:
        return LucideIcons.diamond;
      default:
        return LucideIcons.circle;
    }
  }

  Color _getOptionColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      const Color(0xFF8E24AA), // Purple
    ];
    return colors[index % colors.length];
  }
}
