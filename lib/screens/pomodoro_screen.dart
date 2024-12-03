import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/pomodoro_provider.dart';
import 'pomodoro_settings_screen.dart';

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
            const Center(
              child: Text(
                'List View',
                style: TextStyle(color: Colors.white),
              ),
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