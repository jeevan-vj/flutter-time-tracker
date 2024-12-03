import 'package:flutter/material.dart';
import '../models/timer_entry.dart';

class MockData {
  static final List<TimerEntry> yesterdayEntries = [
    TimerEntry(
      description: 'Flutter Development',
      project: 'Mobile App',
      duration: const Duration(hours: 3, minutes: 45),
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      projectColor: Colors.blue,
    ),
    TimerEntry(
      description: 'Team Meeting',
      project: 'Management',
      duration: const Duration(hours: 1, minutes: 30),
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      projectColor: Colors.green,
    ),
    TimerEntry(
      description: 'API Integration',
      project: 'Backend',
      duration: const Duration(hours: 2, minutes: 15),
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      projectColor: Colors.purple,
    ),
  ];

  static final List<TimerEntry> todayEntries = [
    TimerEntry(
      description: 'Code Review',
      project: 'Development',
      duration: const Duration(hours: 1, minutes: 20),
      timestamp: DateTime.now(),
      projectColor: Colors.orange,
    ),
    TimerEntry(
      description: 'Bug Fixes',
      project: 'Mobile App',
      duration: const Duration(minutes: 45),
      timestamp: DateTime.now(),
      projectColor: Colors.blue,
    ),
    TimerEntry(
      description: 'Documentation',
      project: 'Development',
      duration: const Duration(minutes: 30),
      timestamp: DateTime.now(),
      projectColor: Colors.orange,
    ),
  ];

  static Duration getTotalDuration(List<TimerEntry> entries) {
    return entries.fold(
      Duration.zero,
      (total, entry) => total + entry.duration,
    );
  }
} 