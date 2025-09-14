import 'package:lakshya/features/student/models/college_model.dart';
import 'package:lakshya/features/student/repository/government_data_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'college_view_model.g.dart';

@riverpod
class CollegeViewModel extends _$CollegeViewModel {
  late final GovernmentDataRepository _governmentDataRepository;

  @override
  AsyncValue<List<CollegeModel>>? build() {
    _governmentDataRepository = ref.watch(governmentDataRepositoryProvider);
    return null;
  }

  Future<void> fetchColleges() async {
    state = const AsyncValue.loading();
    final result = await _governmentDataRepository.fetchColleges();
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (colleges) => AsyncValue.data(colleges),
    );
  }
}
