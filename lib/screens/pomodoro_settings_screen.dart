import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pomodoro_provider.dart';

class PomodoroSettingsScreen extends StatelessWidget {
  const PomodoroSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pomodoro settings',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color(0xFFE371AA),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<PomodoroProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              const _SectionHeader('TIME INTERVALS'),
              _SettingsItem(
                title: 'Focus',
                value: '${provider.focusTimeMinutes} min',
                onTap: () {
                  // Show time picker dialog
                  _showTimePickerDialog(
                    context,
                    provider.focusTimeMinutes,
                    (minutes) => provider.setFocusTime(minutes),
                  );
                },
              ),
              _SettingsItem(
                title: 'Break',
                value: '${provider.breakTimeMinutes} min',
                onTap: () {
                  _showTimePickerDialog(
                    context,
                    provider.breakTimeMinutes,
                    (minutes) => provider.setBreakTime(minutes),
                  );
                },
              ),
              const _SectionHeader('AUTO-START'),
              _SettingsSwitch(
                title: 'Auto-start focus sessions',
                value: provider.autoStartFocus,
                onChanged: provider.setAutoStartFocus,
              ),
              _SettingsSwitch(
                title: 'Auto-start breaks',
                value: provider.autoStartBreaks,
                onChanged: provider.setAutoStartBreaks,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Auto-start options only work when the app is open and not in the background.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              const _SectionHeader('GENERAL'),
              _SettingsSwitch(
                title: 'Countdown timer',
                value: provider.countdownTimer,
                onChanged: provider.setCountdownTimer,
              ),
              _SettingsSwitch(
                title: 'Notifications',
                value: provider.notifications,
                onChanged: provider.setNotifications,
              ),
              _SettingsSwitch(
                title: 'Prevent screen lock',
                value: provider.preventScreenLock,
                onChanged: provider.setPreventScreenLock,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Keeps the screen from locking when full-screen mode is turned on.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTimePickerDialog(
    BuildContext context,
    int currentValue,
    Function(int) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => TimePickerDialog(
        currentValue: currentValue,
        onChanged: onChanged,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(color: Colors.grey[400]),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFFE371AA),
    );
  }
}

class TimePickerDialog extends StatefulWidget {
  final int currentValue;
  final Function(int) onChanged;

  const TimePickerDialog({
    super.key,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  State<TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2D2C31),
      title: const Text(
        'Select Duration',
        style: TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        height: 200,
        child: ListWheelScrollView(
          itemExtent: 40,
          children: List.generate(60, (index) {
            return Center(
              child: Text(
                '$index min',
                style: TextStyle(
                  color: selectedValue == index ? Colors.white : Colors.grey,
                  fontSize: selectedValue == index ? 20 : 16,
                ),
              ),
            );
          }),
          onSelectedItemChanged: (index) {
            setState(() {
              selectedValue = index;
            });
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onChanged(selectedValue);
            Navigator.pop(context);
          },
          child: const Text(
            'Done',
            style: TextStyle(color: Color(0xFFE371AA)),
          ),
        ),
      ],
    );
  }
} 