import 'package:flutter/foundation.dart';

class TaskProvider extends ChangeNotifier {
  final List<String> _tasks = [];
  final Map<String, Duration> _taskDurations = {};

  List<String> get tasks => List.unmodifiable(_tasks);
  Map<String, Duration> get taskDurations => Map.unmodifiable(_taskDurations);

  void addTask(String taskName) {
    if (taskName.trim().isNotEmpty) {
      _tasks.add(taskName);
      _taskDurations[taskName] = Duration.zero;
      notifyListeners();
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      final taskName = _tasks[index];
      _tasks.removeAt(index);
      _taskDurations.remove(taskName);
      notifyListeners();
    }
  }

  void updateTaskTime(String taskName, Duration duration) {
    if (_taskDurations.containsKey(taskName)) {
      _taskDurations[taskName] = _taskDurations[taskName]! + duration;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getTaskSummary() {
    return _tasks.map((task) {
      return {
        'task': task,
        'duration': _taskDurations[task] ?? Duration.zero,
      };
    }).toList();
  }
} 