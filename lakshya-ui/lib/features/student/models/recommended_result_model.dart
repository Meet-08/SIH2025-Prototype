class RecommendationResultModel {
  final String recommendedStream;
  final String aiReasoning;

  RecommendationResultModel({
    required this.recommendedStream,
    required this.aiReasoning,
  });

  factory RecommendationResultModel.fromJson(Map<String, dynamic> json) {
    return RecommendationResultModel(
      recommendedStream: json['recommended_stream'] as String,
      aiReasoning: json['ai_reasoning'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommended_stream': recommendedStream,
      'ai_reasoning': aiReasoning,
    };
  }
}
