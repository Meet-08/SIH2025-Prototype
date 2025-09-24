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
    final opts = question.options ?? const <String>[];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: opts.asMap().entries.map((entry) {
          final int i = entry.key;
          final String option = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: i < opts.length - 1 ? 6.0 : 0.0),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onOptionSelected(i),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getOptionColor(i).withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getOptionColor(i).withValues(alpha: 0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Option indicator - more compact
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _getOptionColor(i).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getOptionColor(i),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + i), // A, B, C, D
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _getOptionColor(i),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Option text - more compact
                        Expanded(
                          child: Text(
                            option,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Arrow icon - smaller
                        Icon(
                          LucideIcons.chevron_right,
                          color: _getOptionColor(i),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
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
