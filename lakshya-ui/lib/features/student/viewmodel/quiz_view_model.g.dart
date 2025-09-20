// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QuizViewModel)
const quizViewModelProvider = QuizViewModelProvider._();

final class QuizViewModelProvider
    extends
        $NotifierProvider<
          QuizViewModel,
          AsyncValue<RecommendationResultModel>?
        > {
  const QuizViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quizViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quizViewModelHash();

  @$internal
  @override
  QuizViewModel create() => QuizViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RecommendationResultModel>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<RecommendationResultModel>?>(value),
    );
  }
}

String _$quizViewModelHash() => r'fc0f7854e6145f9597409fab0b221ca4ae99de81';

abstract class _$QuizViewModel
    extends $Notifier<AsyncValue<RecommendationResultModel>?> {
  AsyncValue<RecommendationResultModel>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<RecommendationResultModel>?,
              AsyncValue<RecommendationResultModel>?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<RecommendationResultModel>?,
                AsyncValue<RecommendationResultModel>?
              >,
              AsyncValue<RecommendationResultModel>?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
