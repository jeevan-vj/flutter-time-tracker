import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_entry_event.dart';
part 'time_entry_bloc.freezed.dart';

class TimeEntryBloc extends Bloc<TimeEntryEvent, TimeEntryState> {
  final TimerRepository _timerRepository;
  Timer? _timer;

  TimeEntryBloc({
    required TimerRepository timerRepository,
  }) : _timerRepository = timerRepository,
       super(TimeEntryState.initial()) {
    on<TimeEntryStarted>(_onStarted);
    on<TimeEntryPaused>(_onPaused);
    on<TimeEntryStopped>(_onStopped);
    on<TimeEntryTaskUpdated>(_onTaskUpdated);
    on<TimeEntryProjectSelected>(_onProjectSelected);
  }

  void _onStarted(TimeEntryStarted event, Emitter<TimeEntryState> emit) {
    // Implementation
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
} 