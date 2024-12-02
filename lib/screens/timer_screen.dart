import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../providers/task_provider.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Display
            Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.tasks.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Add tasks in the Tasks tab to start tracking time',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Task',
                      border: OutlineInputBorder(),
                    ),
                    value: taskProvider.tasks.first,
                    items: taskProvider.tasks.map((task) {
                      return DropdownMenuItem(
                        value: task,
                        child: Text(task),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Store selected task
                      if (value != null) {
                        // TODO: Store selected task
                      }
                    },
                  ),
                );
              },
            ),
            Consumer<TimerProvider>(
              builder: (context, timer, child) {
                print('Rebuilding timer display: ${timer.elapsedTime.inSeconds}'); // Debug print
                return Text(
                  _formatDuration(timer.elapsedTime),
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            // Buttons Row
            Consumer<TimerProvider>(
              builder: (context, timer, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: timer.isRunning ? null : timer.startTimer,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: timer.isRunning 
                        ? () => timer.pauseTimer(context) 
                        : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Pause',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: timer.elapsedTime.inSeconds > 0 ? timer.resetTimer : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 