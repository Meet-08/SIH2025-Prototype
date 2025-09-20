// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'career_map_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CareerMapViewModel)
const careerMapViewModelProvider = CareerMapViewModelProvider._();

final class CareerMapViewModelProvider
    extends $NotifierProvider<CareerMapViewModel, AsyncValue<CareerMapModel>?> {
  const CareerMapViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'careerMapViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$careerMapViewModelHash();

  @$internal
  @override
  CareerMapViewModel create() => CareerMapViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<CareerMapModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<CareerMapModel>?>(value),
    );
  }
}

String _$careerMapViewModelHash() =>
    r'50519196898cc2949ad6a41ebe0c59e4f2ed4e9e';

abstract class _$CareerMapViewModel
    extends $Notifier<AsyncValue<CareerMapModel>?> {
  AsyncValue<CareerMapModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<CareerMapModel>?, AsyncValue<CareerMapModel>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<CareerMapModel>?,
                AsyncValue<CareerMapModel>?
              >,
              AsyncValue<CareerMapModel>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
