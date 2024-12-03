import 'package:flutter/material.dart';
import '../models/timer_entry.dart';

class TimerEntriesProvider extends ChangeNotifier {
  final List<TimerEntry> _entries = [];
  
  List<TimerEntry> get entries => List.unmodifiable(_entries);

  void addEntry(TimerEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void deleteEntry(TimerEntry entry) {
    _entries.remove(entry);
    notifyListeners();
  }

  void updateEntryDuration(TimerEntry entry, Duration newDuration) {
    final index = _entries.indexOf(entry);
    if (index != -1) {
      _entries[index] = TimerEntry(
        description: entry.description,
        project: entry.project,
        duration: newDuration,
        timestamp: entry.timestamp,
        projectColor: entry.projectColor,
      );
      notifyListeners();
    }
  }

  List<TimerEntry> getEntriesForDate(DateTime date) {
    return _entries.where((entry) {
      return entry.timestamp.year == date.year &&
             entry.timestamp.month == date.month &&
             entry.timestamp.day == date.day;
    }).toList();
  }
} 