import 'package:freezed_annotation/freezed_annotation.dart';

@freezed
class TimeEntry with _$TimeEntry {
  const factory TimeEntry({
    required String id,
    required String description,
    required DateTime startTime,
    required DateTime? endTime,
    required Duration duration,
    required Project? project,
  }) = _TimeEntry;
} 