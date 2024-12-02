import 'package:flutter/foundation.dart';

class TaskProvider extends ChangeNotifier {
  final List<String> _tasks = [];

  List<String> get tasks => List.unmodifiable(_tasks);

  void addTask(String taskName) {
    if (taskName.trim().isNotEmpty) {
      _tasks.add(taskName);
      notifyListeners();
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      notifyListeners();
    }
  }
} 