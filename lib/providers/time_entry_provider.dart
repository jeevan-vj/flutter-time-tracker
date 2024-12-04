import 'package:flutter/foundation.dart';
import '../models/time_entry.dart';

class TimeEntryProvider extends ChangeNotifier {
  final List<TimeEntry> _entries = [];
  TimeEntry? _currentEntry;
  bool _isRunning = false;
  Duration _elapsed = Duration.zero;

  // Getters
  List<TimeEntry> get entries => List.unmodifiable(_entries);
  TimeEntry? get currentEntry => _currentEntry;
  bool get isRunning => _isRunning;
  Duration get elapsed => _elapsed;

  // Methods for managing time entries
  void startNewEntry({
    required String description,
    required String project,
    DateTime? startTime,
  }) {
    _currentEntry = TimeEntry(
      id: DateTime.now().toString(),
      description: description,
      project: project,
      startTime: startTime ?? DateTime.now(),
      endTime: DateTime.now(),
    );
    _isRunning = true;
    notifyListeners();
  }

  void pauseCurrentEntry() {
    if (_currentEntry != null) {
      _isRunning = false;
      notifyListeners();
    }
  }

  void resumeCurrentEntry() {
    if (_currentEntry != null) {
      _isRunning = true;
      notifyListeners();
    }
  }

  void stopCurrentEntry() {
    if (_currentEntry != null) {
      final completedEntry = TimeEntry(
        id: _currentEntry!.id,
        description: _currentEntry!.description,
        project: _currentEntry!.project,
        startTime: _currentEntry!.startTime,
        endTime: DateTime.now(),
      );
      _entries.insert(0, completedEntry); // Add to beginning of list
      _currentEntry = null;
      _isRunning = false;
      _elapsed = Duration.zero;
      notifyListeners();
    }
  }

  void updateElapsed(Duration elapsed) {
    _elapsed = elapsed;
    notifyListeners();
  }

  void updateEntry(TimeEntry updatedEntry) {
    final index = _entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      _entries[index] = updatedEntry;
      notifyListeners();
    }
  }

  void deleteEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
