import 'package:flutter/material.dart';

class TimerEntry {
  final String id;
  final String description;
  final String project;
  final Duration duration;
  final DateTime timestamp;
  final Color projectColor;

  TimerEntry({
    required this.id,
    required this.description,
    required this.project,
    required this.duration,
    required this.timestamp,
    required this.projectColor,
  });
}
