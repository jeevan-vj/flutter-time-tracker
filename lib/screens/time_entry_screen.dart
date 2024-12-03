import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import '../providers/timer_entries_provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import '../widgets/project_selector_sheet.dart';
import '../models/timer_entry.dart';

class TimeEntryScreen extends StatefulWidget {
  const TimeEntryScreen({super.key});

  @override
  State<TimeEntryScreen> createState() => _TimeEntryScreenState();
}

class _TimeEntryScreenState extends State<TimeEntryScreen> {
  final _taskController = TextEditingController();
  Project? _selectedProject;
  DateTime? _startTime;
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} ${time.hour < 12 ? 'AM' : 'PM'}';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _taskController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      if (_timer == null) {
        // Start or Resume the timer
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          setState(() {
            if (_startTime == null) {
              _startTime = DateTime.now();
            }
            _elapsed = DateTime.now().difference(_startTime!);
          });
        });
      } else {
        // Pause the timer
        _timer?.cancel();
        _timer = null;
      }
    });
  }

  void _showProjectSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2C31),
      builder: (context) => ProjectSelectorSheet(
        onProjectSelected: (project) {
          setState(() {
            _selectedProject = project;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _stopAndSaveTimer() {
    // Stop the timer
    _timer?.cancel();
    
    // Create and save the time entry
    final entry = TimerEntry(
      description: _taskController.text,
      project: _selectedProject?.name ?? 'No Project',
      duration: _elapsed,
      timestamp: _startTime ?? DateTime.now(),
      projectColor: _selectedProject?.color ?? Colors.grey,
    );
    
    // Add to timer entries
    context.read<TimerEntriesProvider>().addEntry(entry);
    
    // Close the screen
    Navigator.pop(context);
  }

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
          const SizedBox(height: 16),
          // Description Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _taskController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "I'm working on...",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Project and Tags
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _showProjectSelector,
                  icon: _selectedProject != null
                      ? Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _selectedProject!.color,
                            shape: BoxShape.circle,
                          ),
                        )
                      : const Icon(Icons.add),
                  label: Text(
                    _selectedProject?.name ?? 'Add a project',
                    style: TextStyle(
                      color: _selectedProject != null ? Colors.white : Colors.grey[400],
                    ),
                  ),
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
          const SizedBox(height: 16),
          // Timer Control Buttons
          Center(
            child: _startTime != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _startTimer, // This will handle both pause and resume
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE371AA),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _timer != null ? Icons.pause : Icons.play_arrow,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _timer != null ? 'Pause' : 'Resume',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _stopAndSaveTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.stop, size: 28),
                            SizedBox(width: 8),
                            Text(
                              'Stop',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _taskController.text.trim().isNotEmpty
                        ? _startTimer
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE371AA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      disabledBackgroundColor: Colors.grey[800],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'Start Timer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 16),
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
          const Spacer(),
          // Timer Circle
          Expanded(
            flex: 3,
            child: Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: TimeEntryPainter(
                    progress: _startTime != null
                        ? (_elapsed.inMinutes + (_elapsed.inSeconds % 60) / 60.0) / 60.0
                        : 0.0,
                    color: const Color(0xFFE371AA),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'DURATION',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatDuration(_elapsed),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_startTime != null)
                          Text(
                            '${_formatTime(_startTime!)} - ${_formatTime(DateTime.now())}',
                            style: const TextStyle(
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
              mainAxisAlignment: MainAxisAlignment.start,
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

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw numbers (0-60 by 5s)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var i = 0; i < 12; i++) {
      final number = (i * 5).toString();
      textPainter.text = TextSpan(
        text: number,
        style: TextStyle(
          color: i == 0 ? color : Colors.grey[600], // Highlight 60 (0)
          fontSize: 14,
          fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
        ),
      );
      textPainter.layout();

      final angle = (i * 30 - 90) * pi / 180; // Start from top (90 degrees offset)
      final offset = Offset(
        center.dx + (radius - 30) * cos(angle) - textPainter.width / 2,
        center.dy + (radius - 30) * sin(angle) - textPainter.height / 2,
      );

      textPainter.paint(canvas, offset);
    }

    // Draw tick marks
    for (var i = 0; i < 60; i++) {
      final tickLength = i % 5 == 0 ? 10.0 : 5.0;
      final angle = (i * 6 - 90) * pi / 180; // Start from top
      final dx = center.dx + (radius - tickLength) * cos(angle);
      final dy = center.dy + (radius - tickLength) * sin(angle);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      canvas.drawLine(
        Offset(dx, dy),
        Offset(x, y),
        Paint()
          ..color = Colors.grey[800]!
          ..strokeWidth = i % 5 == 0 ? 2 : 1,
      );
    }

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 15),
      -pi / 2, // Start from top
      2 * pi * progress,
      false,
      progressPaint,
    );

    // Draw play/pause button at current position
    final buttonRadius = 15.0;
    final buttonAngle = 2 * pi * progress - pi / 2; // Start from top
    final buttonCenter = Offset(
      center.dx + (radius - 15) * cos(buttonAngle),
      center.dy + (radius - 15) * sin(buttonAngle),
    );

    canvas.drawCircle(
      buttonCenter,
      buttonRadius,
      Paint()..color = color,
    );

    // Draw play/pause icon based on timer state
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    if (progress > 0) {
      // Draw pause icon
      canvas.drawRect(
        Rect.fromCenter(
          center: buttonCenter.translate(-4, 0),
          width: 3,
          height: 10,
        ),
        iconPaint,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: buttonCenter.translate(4, 0),
          width: 3,
          height: 10,
        ),
        iconPaint,
      );
    } else {
      // Draw play icon
      canvas.drawPath(
        Path()
          ..moveTo(buttonCenter.dx - 4, buttonCenter.dy - 6)
          ..lineTo(buttonCenter.dx + 6, buttonCenter.dy)
          ..lineTo(buttonCenter.dx - 4, buttonCenter.dy + 6)
          ..close(),
        iconPaint,
      );
    }
  }

  @override
  bool shouldRepaint(TimeEntryPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
} 