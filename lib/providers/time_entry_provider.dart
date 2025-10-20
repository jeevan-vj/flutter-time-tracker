import 'package:flutter/foundation.dart';
import '../models/time_entry.dart';

class TimeEntryProvider extends ChangeNotifier {
  final List<TimeEntry> _entries = [];
  TimeEntry? _currentEntry;
  bool _isRunning = false;
  Duration _elapsed = Duration.zero;

  // Singleton instance to track if any timer is running globally
  static bool _globalTimerActive = false;
  static String? _activeTimerSource;

  // Getters
  List<TimeEntry> get entries => List.unmodifiable(_entries);
  TimeEntry? get currentEntry => _currentEntry;
  bool get isRunning => _isRunning;
  Duration get elapsed => _elapsed;

  // Global timer state getters
  static bool get isAnyTimerActive => _globalTimerActive;
  static String? get activeTimerSource => _activeTimerSource;

  // Helper methods for global timer coordination
  void _setGlobalTimerActive(String source) {
    if (_globalTimerActive && _activeTimerSource != source) {
      debugPrint(
        'WARNING: Timer conflict! $source is starting while $_activeTimerSource is active'
      );
    }
    _globalTimerActive = true;
    _activeTimerSource = source;
  }

  void _setGlobalTimerInactive() {
    _globalTimerActive = false;
    _activeTimerSource = null;
  }

  // Methods for managing time entries
  void startNewEntry({
    required String description,
    required String project,
    DateTime? startTime,
  }) {
    _setGlobalTimerActive('TimeEntryProvider');

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
      _setGlobalTimerInactive();
      notifyListeners();
    }
  }

  void resumeCurrentEntry() {
    if (_currentEntry != null) {
      _setGlobalTimerActive('TimeEntryProvider');
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
      _setGlobalTimerInactive();
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

  // Method to get an entry by ID
  TimeEntry? getEntryById(String id) {
    try {
      return _entries.firstWhere((entry) => entry.id == id);
    } catch (e) {
      return null;
    }
  }
}
