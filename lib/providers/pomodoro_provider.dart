import 'dart:async';
import 'package:flutter/foundation.dart';

class PomodoroProvider extends ChangeNotifier {
  // Timer settings
  int _focusTimeMinutes = 25;
  int _breakTimeMinutes = 5;
  
  // Auto-start settings
  bool _autoStartFocus = false;
  bool _autoStartBreaks = true;
  
  // General settings
  bool _countdownTimer = true;
  bool _notifications = false;
  bool _preventScreenLock = true;

  // Timer state
  int _currentTime = 25 * 60;
  bool _isRunning = false;
  Timer? _timer;
  String _focusTask = '';
  double _progress = 1.0;

  // Getters
  int get focusTimeMinutes => _focusTimeMinutes;
  int get breakTimeMinutes => _breakTimeMinutes;
  bool get autoStartFocus => _autoStartFocus;
  bool get autoStartBreaks => _autoStartBreaks;
  bool get countdownTimer => _countdownTimer;
  bool get notifications => _notifications;
  bool get preventScreenLock => _preventScreenLock;
  int get currentTime => _currentTime;
  bool get isRunning => _isRunning;
  String get focusTask => _focusTask;
  double get progress => _progress;

  // Settings setters
  void setFocusTime(int minutes) {
    _focusTimeMinutes = minutes;
    resetTimer();
    notifyListeners();
  }

  void setBreakTime(int minutes) {
    _breakTimeMinutes = minutes;
    notifyListeners();
  }

  void setAutoStartFocus(bool value) {
    _autoStartFocus = value;
    notifyListeners();
  }

  void setAutoStartBreaks(bool value) {
    _autoStartBreaks = value;
    notifyListeners();
  }

  void setCountdownTimer(bool value) {
    _countdownTimer = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notifications = value;
    notifyListeners();
  }

  void setPreventScreenLock(bool value) {
    _preventScreenLock = value;
    notifyListeners();
  }

  // Existing timer methods...
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
          _progress = _currentTime / (_focusTimeMinutes * 60);
          notifyListeners();
        } else {
          stopTimer();
          if (_autoStartBreaks) {
            // TODO: Start break timer
          }
        }
      });
      notifyListeners();
    }
  }

  void resetTimer() {
    _timer?.cancel();
    _currentTime = _focusTimeMinutes * 60;
    _isRunning = false;
    _progress = 1.0;
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
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

  // ... other existing methods
} 