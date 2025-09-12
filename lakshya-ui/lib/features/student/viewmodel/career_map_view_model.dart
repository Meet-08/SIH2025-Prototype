import 'package:lakshya/features/student/models/career_map_model.dart';
import 'package:lakshya/features/student/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'career_map_view_model.g.dart';

@riverpod
class CareerMapViewModel extends _$CareerMapViewModel {
  late final ApiService _apiService;

  @override
  AsyncValue<CareerMapModel>? build() {
    _apiService = ref.watch(apiServiceProvider);
    return null;
  }

  Future<void> fetchCareerMap(String careerField) async {
    state = const AsyncValue.loading();
    final result = await _apiService.getCareerMap(careerField);
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (careerMap) => AsyncValue.data(careerMap),
    );
  }
}
