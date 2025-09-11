import 'package:lakshya/core/constants/scoring_rules.dart';
import 'package:lakshya/features/student/models/recommended_result_model.dart';

RecommendationResult calculateRecommendation(Map<int, dynamic> answers) {
  Map<String, int> streamScores = {
    'Science': 0,
    'Commerce': 0,
    'Art': 0,
    'ITI/Diploma': 0,
  };

  Map<String, int> domainScores = {
    'Logical': 0,
    'Creative': 0,
    'Social': 0,
    'Technical': 0,
  };

  answers.forEach((questionIndex, answerValue) {
    if (scoringRules.containsKey(questionIndex) &&
        scoringRules[questionIndex]![answerValue] != null) {
      scoringRules[questionIndex]![answerValue]!.forEach((stream, points) {
        streamScores[stream] = streamScores[stream]! + points;
      });
    }

    if (domainScoringRules.containsKey(questionIndex) &&
        domainScoringRules[questionIndex]![answerValue] != null) {
      domainScoringRules[questionIndex]![answerValue]!.forEach((
        domain,
        points,
      ) {
        domainScores[domain] = domainScores[domain]! + points;
      });
    }
  });

  String recommendedStream = streamScores.entries.reduce((a, b) {
    return a.value >= b.value ? a : b;
  }).key;

  return RecommendationResult(
    recommendedStream: recommendedStream,
    streamScores: streamScores,
    domainScores: domainScores,
  );
}
