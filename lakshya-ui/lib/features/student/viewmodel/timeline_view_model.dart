import 'package:lakshya/core/constants/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timeline_view_model.g.dart';

// Filter options for timeline
enum TimelineFilter {
  all,
  upcoming,
  active,
  completed,
  admissions,
  scholarships,
  exams,
}

// Timeline state management using modern riverpod approach
@riverpod
class TimelineViewModel extends _$TimelineViewModel {
  @override
  List<TimelineEvent> build() {
    // Sort events by date (chronological order)
    final sortedEvents = List<TimelineEvent>.from(timelineEvents)
      ..sort((a, b) => a.date.compareTo(b.date));
    return sortedEvents;
  }

  List<TimelineEvent> getFilteredEvents(TimelineFilter filter) {
    final events = state;

    switch (filter) {
      case TimelineFilter.upcoming:
        return events
            .where((e) => e.status == TimelineEventStatus.upcoming)
            .toList();
      case TimelineFilter.active:
        return events
            .where((e) => e.status == TimelineEventStatus.active)
            .toList();
      case TimelineFilter.completed:
        return events
            .where((e) => e.status == TimelineEventStatus.completed)
            .toList();
      case TimelineFilter.admissions:
        return events
            .where((e) => e.type == TimelineEventType.admission)
            .toList();
      case TimelineFilter.scholarships:
        return events
            .where((e) => e.type == TimelineEventType.scholarship)
            .toList();
      case TimelineFilter.exams:
        return events.where((e) => e.type == TimelineEventType.exam).toList();
      case TimelineFilter.all:
        return events;
    }
  }

  Future<void> refresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this would fetch new data from an API
    ref.invalidateSelf();
  }
}

@riverpod
Map<String, int> timelineEventCounts(Ref ref) {
  final events = ref.watch(timelineViewModelProvider);
  return {
    'upcoming': events
        .where((e) => e.status == TimelineEventStatus.upcoming)
        .length,
    'active': events
        .where((e) => e.status == TimelineEventStatus.active)
        .length,
    'completed': events
        .where((e) => e.status == TimelineEventStatus.completed)
        .length,
  };
}

@riverpod
TimelineEvent? nextImportantEvent(Ref ref) {
  final events = ref.watch(timelineViewModelProvider);
  final upcomingEvents =
      events
          .where(
            (e) =>
                e.status == TimelineEventStatus.upcoming ||
                e.status == TimelineEventStatus.active,
          )
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

  return upcomingEvents.isNotEmpty ? upcomingEvents.first : null;
}

@riverpod
List<TimelineEvent> filteredTimelineEvents(Ref ref, TimelineFilter filter) {
  final viewModel = ref.watch(timelineViewModelProvider.notifier);
  return viewModel.getFilteredEvents(filter);
}
