import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/timer_entry.dart';

class TimerProvider extends ChangeNotifier {
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;
  String? _currentTask;
  TimerEntry? _activeEntry;
  Timer? _entryTimer;

  Duration get elapsedTime => _elapsedTime;
  bool get isRunning => _isRunning;
  String? get currentTask => _currentTask;
  TimerEntry? get activeEntry => _activeEntry;

  void setCurrentTask(String task) {
    _currentTask = task;
    notifyListeners();
  }

  void startTimer() {
    if (!_isRunning && _currentTask != null) {
      print('Starting timer for task: $_currentTask');
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _elapsedTime += const Duration(seconds: 1);
        print('Timer tick: ${_elapsedTime.inSeconds}');
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void pauseTimer(BuildContext context) {
    print('Pausing timer...');
    _timer?.cancel();
    if (_currentTask != null) {
      // Update task duration in TaskProvider
      context.read<TaskProvider>().updateTaskTime(_currentTask!, _elapsedTime);
    }
    _isRunning = false;
    _elapsedTime = Duration.zero;
    notifyListeners();
  }

  void resetTimer() {
    print('Resetting timer...');
    _timer?.cancel();
    _elapsedTime = Duration.zero;
    _isRunning = false;
    notifyListeners();
  }

  void startEntryTimer(TimerEntry entry) {
    if (_activeEntry != entry) {
      stopEntryTimer();
      _activeEntry = entry;
      _entryTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        // Update entry duration
        // Note: Since TimerEntry is immutable, we'll need to create a new instance
        // TODO: Implement proper state management for entries
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void stopEntryTimer() {
    _entryTimer?.cancel();
    _entryTimer = null;
    _activeEntry = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _entryTimer?.cancel();
    super.dispose();
  }
} 