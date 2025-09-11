class RecommendationResult {
  final String recommendedStream;
  final Map<String, int> streamScores;
  final Map<String, int> domainScores;

  RecommendationResult({
    required this.recommendedStream,
    required this.streamScores,
    required this.domainScores,
  });
}
