import 'package:lakshya/features/student/models/recommended_result_model.dart';
import 'package:lakshya/features/student/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'quiz_view_model.g.dart';

@riverpod
class QuizViewModel extends _$QuizViewModel {
  late final ApiService _apiService;

  @override
  AsyncValue<RecommendationResultModel>? build() {
    _apiService = ref.watch(apiServiceProvider);
    return null;
  }

  Future<void> fetchRecommendations(Map<int, int> answers) async {
    state = const AsyncValue.loading();
    final result = await _apiService.getRecommendation(answers);
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (recommendationResult) => AsyncValue.data(recommendationResult),
    );
  }
}
