// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'government_data_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(governmentDataRepository)
const governmentDataRepositoryProvider = GovernmentDataRepositoryProvider._();

final class GovernmentDataRepositoryProvider
    extends
        $FunctionalProvider<
          GovernmentDataRepository,
          GovernmentDataRepository,
          GovernmentDataRepository
        >
    with $Provider<GovernmentDataRepository> {
  const GovernmentDataRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'governmentDataRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$governmentDataRepositoryHash();

  @$internal
  @override
  $ProviderElement<GovernmentDataRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GovernmentDataRepository create(Ref ref) {
    return governmentDataRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GovernmentDataRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GovernmentDataRepository>(value),
    );
  }
}

String _$governmentDataRepositoryHash() =>
    r'fd77f59ceaddb0cca616e3c9c065201574907af0';
