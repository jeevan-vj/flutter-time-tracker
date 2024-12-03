import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/pomodoro_provider.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F), // Dark background
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
      ),
      body: Column(
        children: [
          // Mode Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2D2C31),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ModeButton(
                      title: 'List',
                      isSelected: false,
                      onTap: () {
                        // TODO: Switch to list mode
                      },
                    ),
                  ),
                  Expanded(
                    child: _ModeButton(
                      title: 'Pomodoro',
                      isSelected: true,
                      onTap: () {
                        // TODO: Switch to pomodoro mode
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Focus Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
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
                ElevatedButton(
                  onPressed: () {
                    // TODO: Start/Pause timer
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE371AA), // Pink color
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Start session',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    // TODO: Open Pomodoro settings
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
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF49464E) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class PomodoroTimer extends StatelessWidget {
  const PomodoroTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: TimerPainter(
              progress: 0.7, // TODO: Get from provider
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
            const Text(
              '25:00',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready?',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
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

    // Draw background circle (tick marks)
    final tickPaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, tickPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.14159 / 180), // Start from top (90 degrees)
      progress * 2 * 3.14159, // Full circle is 2*PI radians
      false,
      progressPaint,
    );

    // Draw tick marks
    for (var i = 0; i < 60; i++) {
      final tickLength = i % 5 == 0 ? 12.0 : 8.0;
      final angle = i * 6 * (3.14159 / 180); // 6 degrees per tick
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