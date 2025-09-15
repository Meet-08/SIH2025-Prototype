import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lakshya/core/constants/mock_data.dart';
import 'package:lakshya/core/core.dart';
import 'package:table_calendar/table_calendar.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with TickerProviderStateMixin {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fadeAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  List<String> _getEventsForDay(DateTime day) {
    return eventsData[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  IconData _getEventIcon(String event) {
    if (event.toLowerCase().contains('admission')) {
      return LucideIcons.graduation_cap;
    }
    if (event.toLowerCase().contains('scholarship')) return LucideIcons.gift;
    if (event.toLowerCase().contains('neet')) return LucideIcons.stethoscope;
    if (event.toLowerCase().contains('counseling')) {
      return LucideIcons.user_check;
    }
    return LucideIcons.calendar;
  }

  Color _getEventColor(String event) {
    if (event.toLowerCase().contains('admission')) return AppColors.primary;
    if (event.toLowerCase().contains('scholarship')) return AppColors.secondary;
    if (event.toLowerCase().contains('neet')) return AppColors.accent;
    if (event.toLowerCase().contains('counseling')) {
      return AppColors.parentPrimary;
    }
    return AppColors.textSecondary;
  }

  void _showEventsBottomSheet(DateTime selectedDay, List<String> events) {
    if (events.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  gradient: AppGradients.primaryGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        LucideIcons.calendar_days,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Events',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GFBadge(
                      text: events.length.toString(),
                      color: AppColors.accent,
                      textColor: AppColors.onAccent,
                      size: GFSize.SMALL,
                    ),
                  ],
                ),
              ),

              // Events list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: GFListTile(
                        padding: const EdgeInsets.all(16),
                        color: AppColors.surface,
                        shadow: BoxShadow(
                          color: _getEventColor(event).withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                        radius: 12,
                        avatar: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getEventColor(event),
                                _getEventColor(event).withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getEventIcon(event),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          event,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subTitle: Text(
                          'Important deadline - Don\'t miss it!',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                        icon: GFIconButton(
                          onPressed: () {
                            // Handle reminder/notification setting
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(
                                      LucideIcons.bell,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Text('Reminder set for this event!'),
                                  ],
                                ),
                                backgroundColor: AppColors.secondary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(LucideIcons.bell, size: 18),
                          color: _getEventColor(event).withValues(alpha: 0.1),
                          shape: GFIconButtonShape.circle,
                          size: GFSize.SMALL,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.timelineGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        title: Row(
          children: [
            GFIconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(LucideIcons.arrow_left, color: Colors.white),
              color: Colors.white.withValues(alpha: 0.2),
              shape: GFIconButtonShape.circle,
              size: GFSize.MEDIUM,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Timeline & Events',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GFIconButton(
              onPressed: () {
                setState(() {
                  _calendarFormat = _calendarFormat == CalendarFormat.month
                      ? CalendarFormat.twoWeeks
                      : CalendarFormat.month;
                });
              },
              icon: Icon(
                _calendarFormat == CalendarFormat.month
                    ? LucideIcons.calendar_fold
                    : LucideIcons.calendar,
                color: Colors.white,
              ),
              color: Colors.white.withValues(alpha: 0.2),
              shape: GFIconButtonShape.circle,
              size: GFSize.MEDIUM,
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.accent.withValues(alpha: 0.05),
              AppColors.background,
              AppColors.background,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Calendar container with modern design
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: TableCalendar<String>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        calendarFormat: _calendarFormat,
                        eventLoader: _getEventsForDay,
                        startingDayOfWeek: StartingDayOfWeek.monday,

                        // Styling
                        calendarStyle: CalendarStyle(
                          // Outside days
                          outsideDaysVisible: true,
                          weekendTextStyle: TextStyle(
                            color: AppColors.accent.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                          ),

                          // Default days
                          defaultTextStyle: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),

                          // Selected day
                          selectedDecoration: BoxDecoration(
                            gradient: AppGradients.accentGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          selectedTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),

                          // Today
                          todayDecoration: BoxDecoration(
                            gradient: AppGradients.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          todayTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),

                          // Event markers
                          markerDecoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          markersMaxCount: 3,
                          canMarkersOverflow: true,

                          // Cell padding
                          cellMargin: const EdgeInsets.all(4),
                          cellPadding: const EdgeInsets.all(0),
                        ),

                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          leftChevronIcon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              LucideIcons.chevron_left,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          rightChevronIcon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              LucideIcons.chevron_right,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          titleTextStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          headerPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                        ),

                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: TextStyle(
                            color: AppColors.accent.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                          ),
                          weekdayStyle: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });

                          final events = _getEventsForDay(selectedDay);
                          _showEventsBottomSheet(selectedDay, events);
                        },

                        onPageChanged: (focusedDay) {
                          setState(() {
                            _focusedDay = focusedDay;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Upcoming events section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppGradients.secondaryGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                LucideIcons.clock,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Upcoming Events',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Quick upcoming events list
                        ...eventsData.entries
                            .where(
                              (entry) => entry.key.isAfter(
                                DateTime.now().subtract(
                                  const Duration(days: 1),
                                ),
                              ),
                            )
                            .take(3)
                            .map((entry) {
                              final date = entry.key;
                              final events = entry.value;
                              final daysUntil = date
                                  .difference(DateTime.now())
                                  .inDays;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: GFCard(
                                  padding: const EdgeInsets.all(16),
                                  color: AppColors.surface,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: daysUntil <= 7
                                                  ? AppColors.accent.withValues(
                                                      alpha: 0.1,
                                                    )
                                                  : AppColors.primary
                                                        .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              daysUntil == 0
                                                  ? 'Today'
                                                  : daysUntil == 1
                                                  ? 'Tomorrow'
                                                  : '$daysUntil days left',
                                              style: TextStyle(
                                                color: daysUntil <= 7
                                                    ? AppColors.accent
                                                    : AppColors.primary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '${date.day}/${date.month}/${date.year}',
                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ...events.map(
                                        (event) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 4,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                _getEventIcon(event),
                                                color: _getEventColor(event),
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  event,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
