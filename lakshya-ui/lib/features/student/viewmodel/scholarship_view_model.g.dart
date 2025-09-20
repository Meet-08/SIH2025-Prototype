// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scholarship_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ScholarshipViewModel)
const scholarshipViewModelProvider = ScholarshipViewModelProvider._();

final class ScholarshipViewModelProvider
    extends
        $NotifierProvider<
          ScholarshipViewModel,
          AsyncValue<List<ScholarshipModel>>?
        > {
  const ScholarshipViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scholarshipViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scholarshipViewModelHash();

  @$internal
  @override
  ScholarshipViewModel create() => ScholarshipViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<ScholarshipModel>>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<ScholarshipModel>>?>(
        value,
      ),
    );
  }
}

String _$scholarshipViewModelHash() =>
    r'22bdec1a071fcd0bc781d18ccef60263ee032f44';

abstract class _$ScholarshipViewModel
    extends $Notifier<AsyncValue<List<ScholarshipModel>>?> {
  AsyncValue<List<ScholarshipModel>>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ScholarshipModel>>?,
              AsyncValue<List<ScholarshipModel>>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ScholarshipModel>>?,
                AsyncValue<List<ScholarshipModel>>?
              >,
              AsyncValue<List<ScholarshipModel>>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
