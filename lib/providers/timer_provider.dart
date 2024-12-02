import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerProvider extends ChangeNotifier {
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;

  Duration get elapsedTime => _elapsedTime;
  bool get isRunning => _isRunning;

  void startTimer() {
    if (!_isRunning) {
      print('Starting timer...');
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _elapsedTime += const Duration(seconds: 1);
        print('Timer tick: ${_elapsedTime.inSeconds}');
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void pauseTimer() {
    print('Pausing timer...');
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    print('Resetting timer...');
    _timer?.cancel();
    _elapsedTime = Duration.zero;
    _isRunning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
} 