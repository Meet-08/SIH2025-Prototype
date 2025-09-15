import 'package:lakshya/features/student/models/scholarship_model.dart';
import 'package:lakshya/features/student/repository/government_data_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scholarship_view_model.g.dart';

@riverpod
class ScholarshipViewModel extends _$ScholarshipViewModel {
  late final GovernmentDataRepository _governmentDataRepository;

  @override
  AsyncValue<List<ScholarshipModel>>? build() {
    _governmentDataRepository = ref.watch(governmentDataRepositoryProvider);
    return null;
  }

  Future<void> fetchScholarships() async {
    state = const AsyncValue.loading();
    final result = await _governmentDataRepository.fetchScholarships();
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (scholarships) => AsyncValue.data(scholarships),
    );
  }
}
