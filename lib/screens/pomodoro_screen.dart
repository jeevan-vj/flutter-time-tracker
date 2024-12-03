import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/pomodoro_provider.dart';
import '../providers/timer_provider.dart';
import '../providers/timer_entries_provider.dart';
import 'pomodoro_settings_screen.dart';
import '../models/timer_entry.dart';
import 'time_entry_screen.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1B1F),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Timer',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                // TODO: Add new timer
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                // TODO: Open settings
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2C31),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: const Color(0xFF49464E),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    dividerColor: Colors.transparent,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    tabs: const [
                      Tab(text: 'List'),
                      Tab(text: 'Pomodoro'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // List View
            Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      // Yesterday Section
                      _TimerListSection(
                        title: 'Yesterday',
                        totalDuration: const Duration(hours: 10, minutes: 18, seconds: 58),
                        entries: [
                          TimerEntry(
                            description: 'Fonterra',
                            project: 'work',
                            duration: const Duration(hours: 10, minutes: 18, seconds: 56),
                            timestamp: DateTime.now().subtract(const Duration(days: 1)),
                            projectColor: Colors.pink,
                          ),
                          TimerEntry(
                            description: 'sdf',
                            project: 'CSN',
                            duration: const Duration(seconds: 2),
                            timestamp: DateTime.now().subtract(const Duration(days: 1)),
                            projectColor: Colors.blue,
                          ),
                        ],
                      ),
                      // Today Section
                      _TimerListSection(
                        title: 'Mon, 2 Dec',
                        totalDuration: const Duration(seconds: 5),
                        entries: [
                          TimerEntry(
                            description: 'Add description',
                            project: 'No Project',
                            duration: const Duration(seconds: 5),
                            timestamp: DateTime.now(),
                            projectColor: Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Bottom Input Bar
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2C31),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1B1F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.grid_view,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "I'm working on...",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TimeEntryScreen(),
                              ),
                            );
                          },
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE371AA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Pomodoro View
            Column(
              children: [
                const SizedBox(height: 20),
                // Focus Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Consumer<PomodoroProvider>(
                    builder: (context, pomodoro, child) {
                      return TextField(
                        style: const TextStyle(color: Colors.white),
                        onChanged: pomodoro.setFocusTask,
                        decoration: InputDecoration(
                          hintText: "I'm focusing on...",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: const Color(0xFF2D2C31),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: PomodoroTimer(),
                  ),
                ),
                // Start Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Consumer<PomodoroProvider>(
                        builder: (context, pomodoro, child) {
                          return ElevatedButton(
                            onPressed: () {
                              if (pomodoro.isRunning) {
                                pomodoro.pauseTimer();
                              } else {
                                pomodoro.startTimer();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE371AA),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  pomodoro.isRunning ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  pomodoro.isRunning ? 'Pause session' : 'Start session',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PomodoroSettingsScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Pomodoro settings ›',
                          style: TextStyle(
                            color: Color(0xFFE371AA),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PomodoroTimer extends StatelessWidget {
  const PomodoroTimer({super.key});

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PomodoroProvider>(
      builder: (context, pomodoro, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: TimerPainter(
                  progress: pomodoro.progress,
                  color: const Color(0xFFE371AA),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Focus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatTime(pomodoro.currentTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pomodoro.isRunning ? 'Focus time!' : 'Ready?',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class TimerPainter extends CustomPainter {
  final double progress;
  final Color color;

  TimerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the progress arc (counterclockwise)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      2 * pi * progress, // Draw clockwise
      false,
      progressPaint,
    );

    // Draw tick marks
    for (var i = 0; i < 60; i++) {
      final tickLength = i % 5 == 0 ? 12.0 : 8.0;
      final angle = i * 6 * (pi / 180); // 6 degrees per tick
      final dx = center.dx + (radius - tickLength) * cos(angle);
      final dy = center.dy + (radius - tickLength) * sin(angle);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      canvas.drawLine(
        Offset(dx, dy),
        Offset(x, y),
        Paint()
          ..color = Colors.grey[800]!
          ..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _TimerListSection extends StatelessWidget {
  final String title;
  final Duration totalDuration;
  final List<TimerEntry> entries;

  const _TimerListSection({
    required this.title,
    required this.totalDuration,
    required this.entries,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                _formatDuration(totalDuration),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        ...entries.map((entry) => _TimerEntryCard(entry: entry)).toList(),
      ],
    );
  }
}

class _TimerEntryCard extends StatelessWidget {
  final TimerEntry entry;

  const _TimerEntryCard({required this.entry});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Dismissible(
        key: ValueKey(entry),
        background: Container( // Right swipe (play)
          padding: const EdgeInsets.only(left: 16.0),
          alignment: Alignment.centerLeft,
          color: const Color(0xFFE371AA),
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        secondaryBackground: Container( // Left swipe (delete)
          padding: const EdgeInsets.only(right: 16.0),
          alignment: Alignment.centerRight,
          color: Colors.red,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // Delete confirmation
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color(0xFF2D2C31),
                  title: const Text(
                    'Delete Entry',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Are you sure you want to delete this entry?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            // Start timer for this entry
            context.read<TimerProvider>().startEntryTimer(entry);
            return false; // Don't dismiss the item
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            // Delete the entry
            // TODO: Implement delete functionality
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2C31),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              entry.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            subtitle: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: entry.projectColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  entry.project,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDuration(entry.duration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 