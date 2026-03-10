import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Selected date in the calendar — shared between CozyCalendar and notes
final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Check if selected date is today
final isSelectedDateTodayProvider = Provider<bool>((ref) {
  final selected = ref.watch(selectedDateProvider);
  final now = DateTime.now();
  return selected.year == now.year &&
      selected.month == now.month &&
      selected.day == now.day;
});

/// Calendar expanded state — shared between CozyCalendar and HomeScreen
final calendarExpandedProvider = StateProvider<bool>((ref) => false);
