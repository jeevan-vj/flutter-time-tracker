import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_entries_provider.dart';
import 'dart:math';

class TimeEntryScreen extends StatelessWidget {
  const TimeEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Save time entry
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFFE371AA),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timer Display
          const Center(
            child: Text(
              '0:00:19',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Description Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "I'm working on...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Project and Tags
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Show project selector
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add a project'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[400],
                    side: BorderSide(color: Colors.grey[800]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Show tags selector
                  },
                  icon: const Icon(Icons.tag),
                  label: const Text('Add tags'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[400],
                    side: BorderSide(color: Colors.grey[800]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Time Edit Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Edit time',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Set to last stop time
                  },
                  child: const Text(
                    'Set to last stop time',
                    style: TextStyle(
                      color: Color(0xFFE371AA),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Time Range Display
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _TimeRow(
                  icon: Icons.play_arrow,
                  label: 'Start',
                  time: '1:15 AM',
                  date: '12/04/2024',
                ),
                const SizedBox(height: 8),
                _TimeRow(
                  icon: Icons.stop,
                  label: 'Stop',
                  time: '1:15 AM',
                  date: '12/04/2024',
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time entry is running...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Stop Timer',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Timer Circle
          Expanded(
            child: Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: TimeEntryPainter(
                    progress: 0.3,
                    color: const Color(0xFFE371AA),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'DURATION',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '0:00:19',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '1:15 AM - 1:15 AM',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Bottom Actions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Show more options
                  },
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Generate start link
                      },
                      icon: const Icon(Icons.link),
                      label: const Text('Generate start link'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[400],
                        side: BorderSide(color: Colors.grey[800]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Show QR code
                      },
                      icon: const Icon(Icons.qr_code),
                      label: const Text('QR code'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[400],
                        side: BorderSide(color: Colors.grey[800]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final String date;

  const _TimeRow({
    required this.icon,
    required this.label,
    required this.time,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2C31),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          const Spacer(),
          Text(
            time,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1B1F),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              date,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeEntryPainter extends CustomPainter {
  final double progress;
  final Color color;

  TimeEntryPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw numbers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var i = 0; i < 12; i++) {
      final number = (i * 5).toString();
      textPainter.text = TextSpan(
        text: number,
        style: TextStyle(
          color: i * 5 == 45 ? color : Colors.grey[600],
          fontSize: 14,
        ),
      );
      textPainter.layout();

      final angle = i * 30 * pi / 180;
      final offset = Offset(
        center.dx + (radius - 30) * cos(angle) - textPainter.width / 2,
        center.dy + (radius - 30) * sin(angle) - textPainter.height / 2,
      );

      textPainter.paint(canvas, offset);
    }

    // Draw tick marks
    for (var i = 0; i < 60; i++) {
      final tickLength = i % 5 == 0 ? 10.0 : 5.0;
      final angle = i * 6 * pi / 180;
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

    // Draw progress indicator
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 15),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );

    // Draw play button
    final buttonRadius = 15.0;
    final buttonAngle = 2 * pi * progress - pi / 2;
    final buttonCenter = Offset(
      center.dx + (radius - 15) * cos(buttonAngle),
      center.dy + (radius - 15) * sin(buttonAngle),
    );

    canvas.drawCircle(
      buttonCenter,
      buttonRadius,
      Paint()..color = color,
    );

    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      Path()
        ..moveTo(buttonCenter.dx - 5, buttonCenter.dy - 6)
        ..lineTo(buttonCenter.dx + 5, buttonCenter.dy)
        ..lineTo(buttonCenter.dx - 5, buttonCenter.dy + 6)
        ..close(),
      iconPaint,
    );
  }

  @override
  bool shouldRepaint(TimeEntryPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
} 