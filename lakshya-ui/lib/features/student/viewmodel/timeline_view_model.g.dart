// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TimelineViewModel)
const timelineViewModelProvider = TimelineViewModelProvider._();

final class TimelineViewModelProvider
    extends $NotifierProvider<TimelineViewModel, List<TimelineEvent>> {
  const TimelineViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timelineViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timelineViewModelHash();

  @$internal
  @override
  TimelineViewModel create() => TimelineViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TimelineEvent> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TimelineEvent>>(value),
    );
  }
}

String _$timelineViewModelHash() => r'd07546b3a595fd8ec36b7a5d6d32aa93b899ac15';

abstract class _$TimelineViewModel extends $Notifier<List<TimelineEvent>> {
  List<TimelineEvent> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<TimelineEvent>, List<TimelineEvent>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<TimelineEvent>, List<TimelineEvent>>,
              List<TimelineEvent>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(timelineEventCounts)
const timelineEventCountsProvider = TimelineEventCountsProvider._();

final class TimelineEventCountsProvider
    extends
        $FunctionalProvider<
          Map<String, int>,
          Map<String, int>,
          Map<String, int>
        >
    with $Provider<Map<String, int>> {
  const TimelineEventCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timelineEventCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timelineEventCountsHash();

  @$internal
  @override
  $ProviderElement<Map<String, int>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Map<String, int> create(Ref ref) {
    return timelineEventCounts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, int>>(value),
    );
  }
}

String _$timelineEventCountsHash() =>
    r'556e24de5429ca95a57ec4880faf84adfab738b1';

@ProviderFor(nextImportantEvent)
const nextImportantEventProvider = NextImportantEventProvider._();

final class NextImportantEventProvider
    extends $FunctionalProvider<TimelineEvent?, TimelineEvent?, TimelineEvent?>
    with $Provider<TimelineEvent?> {
  const NextImportantEventProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextImportantEventProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextImportantEventHash();

  @$internal
  @override
  $ProviderElement<TimelineEvent?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TimelineEvent? create(Ref ref) {
    return nextImportantEvent(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimelineEvent? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimelineEvent?>(value),
    );
  }
}

String _$nextImportantEventHash() =>
    r'1788057bf12d7dd1d56732f4b5fda5ae6ac211f1';

@ProviderFor(filteredTimelineEvents)
const filteredTimelineEventsProvider = FilteredTimelineEventsFamily._();

final class FilteredTimelineEventsProvider
    extends
        $FunctionalProvider<
          List<TimelineEvent>,
          List<TimelineEvent>,
          List<TimelineEvent>
        >
    with $Provider<List<TimelineEvent>> {
  const FilteredTimelineEventsProvider._({
    required FilteredTimelineEventsFamily super.from,
    required TimelineFilter super.argument,
  }) : super(
         retry: null,
         name: r'filteredTimelineEventsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredTimelineEventsHash();

  @override
  String toString() {
    return r'filteredTimelineEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<TimelineEvent>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<TimelineEvent> create(Ref ref) {
    final argument = this.argument as TimelineFilter;
    return filteredTimelineEvents(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TimelineEvent> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TimelineEvent>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredTimelineEventsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredTimelineEventsHash() =>
    r'818ee43447ee5fbcb0c3a4ff40261f6e29da30d5';

final class FilteredTimelineEventsFamily extends $Family
    with $FunctionalFamilyOverride<List<TimelineEvent>, TimelineFilter> {
  const FilteredTimelineEventsFamily._()
    : super(
        retry: null,
        name: r'filteredTimelineEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilteredTimelineEventsProvider call(TimelineFilter filter) =>
      FilteredTimelineEventsProvider._(argument: filter, from: this);

  @override
  String toString() => r'filteredTimelineEventsProvider';
}
