import 'dart:async';
import 'package:flutter/foundation.dart';

class PomodoroProvider extends ChangeNotifier {
  static const int defaultFocusTime = 25 * 60; // 25 minutes in seconds
  static const int defaultBreakTime = 5 * 60; // 5 minutes in seconds

  int _currentTime = defaultFocusTime;
  bool _isRunning = false;
  Timer? _timer;
  String _focusTask = '';
  double _progress = 1.0;

  int get currentTime => _currentTime;
  bool get isRunning => _isRunning;
  String get focusTask => _focusTask;
  double get progress => _progress;

  void setFocusTask(String task) {
    _focusTask = task;
    notifyListeners();
  }

  void startTimer() {
    if (!_isRunning) {
      print('Starting timer...'); // Debug print
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_currentTime > 0) {
          _currentTime--;
          // Update progress (1.0 to 0.0 as timer counts down)
          _progress = _currentTime / defaultFocusTime;
          print('Time: $_currentTime, Progress: $_progress'); // Debug print
          notifyListeners();
        } else {
          stopTimer();
        }
      });
      notifyListeners();
    }
  }

  void pauseTimer() {
    print('Pausing timer...'); // Debug print
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    print('Resetting timer...'); // Debug print
    _timer?.cancel();
    _currentTime = defaultFocusTime;
    _isRunning = false;
    _progress = 1.0;
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
} 