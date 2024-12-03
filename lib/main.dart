import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/timer_screen.dart';
import 'screens/task_screen.dart';
import 'screens/summary_screen.dart';
import 'screens/pomodoro_screen.dart';
import 'providers/timer_provider.dart';
import 'providers/task_provider.dart';
import 'providers/pomodoro_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => PomodoroProvider()),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: const TabBarView(
          children: [
            TimerScreen(),
            PomodoroScreen(),
            TaskScreen(),
            SummaryScreen(),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.timer), text: 'Timer'),
            Tab(icon: Icon(Icons.watch_later_outlined), text: 'Pomodoro'),
            Tab(icon: Icon(Icons.task), text: 'Tasks'),
            Tab(icon: Icon(Icons.summarize), text: 'Summary'),
          ],
        ),
      ),
    );
  }
}
