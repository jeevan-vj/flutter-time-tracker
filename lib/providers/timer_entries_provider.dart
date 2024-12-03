import 'package:flutter/material.dart';
import '../models/timer_entry.dart';

class TimerEntriesProvider extends ChangeNotifier {
  final List<TimerEntry> _entries = [];
  
  List<TimerEntry> get entries => List.unmodifiable(_entries);

  void addEntry(TimerEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  List<TimerEntry> getEntriesForDate(DateTime date) {
    return _entries.where((entry) {
      return entry.timestamp.year == date.year &&
             entry.timestamp.month == date.month &&
             entry.timestamp.day == date.day;
    }).toList();
  }

  Duration getTotalDurationForDate(DateTime date) {
    return getEntriesForDate(date).fold(
      Duration.zero,
      (total, entry) => total + entry.duration,
    );
  }

  bool get hasEntries => _entries.isNotEmpty;
} 