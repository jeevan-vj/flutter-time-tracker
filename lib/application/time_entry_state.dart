import 'package:freezed_annotation/freezed_annotation.dart';
import '../domain/time_entry.dart';

part 'time_entry_state.freezed.dart';

@freezed
class TimeEntryState with _$TimeEntryState {
  const factory TimeEntryState({
    required String taskName,
    required DateTime? startTime,
    required DateTime? pauseTime,
    required Duration elapsed,
    required bool isRunning,
    required bool isEditing,
    Project? selectedProject,
  }) = _TimeEntryState;

  factory TimeEntryState.initial() => const TimeEntryState(
    taskName: '',
    startTime: null,
    pauseTime: null,
    elapsed: Duration.zero,
    isRunning: false,
    isEditing: false,
    selectedProject: null,
  );
} 