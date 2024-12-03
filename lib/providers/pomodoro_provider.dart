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
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_currentTime > 0) {
          _currentTime--;
          _progress = _currentTime / defaultFocusTime;
          notifyListeners();
        } else {
          stopTimer();
        }
      });
      notifyListeners();
    }
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
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