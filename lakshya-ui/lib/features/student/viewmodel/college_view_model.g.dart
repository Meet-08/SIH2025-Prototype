// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'college_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CollegeViewModel)
const collegeViewModelProvider = CollegeViewModelProvider._();

final class CollegeViewModelProvider
    extends
        $NotifierProvider<CollegeViewModel, AsyncValue<List<CollegeModel>>?> {
  const CollegeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collegeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collegeViewModelHash();

  @$internal
  @override
  CollegeViewModel create() => CollegeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<CollegeModel>>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<CollegeModel>>?>(
        value,
      ),
    );
  }
}

String _$collegeViewModelHash() => r'b60efa876c0d16d42d5136d7fd0bd2bf09c9168e';

abstract class _$CollegeViewModel
    extends $Notifier<AsyncValue<List<CollegeModel>>?> {
  AsyncValue<List<CollegeModel>>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<CollegeModel>>?,
              AsyncValue<List<CollegeModel>>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CollegeModel>>?,
                AsyncValue<List<CollegeModel>>?
              >,
              AsyncValue<List<CollegeModel>>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
