import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Column(
        children: [
          // Add Task Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AddTaskForm(),
          ),
          // Task List
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(taskProvider.tasks[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => taskProvider.deleteTask(index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _submitTask() {
    if (_taskController.text.trim().isNotEmpty) {
      context.read<TaskProvider>().addTask(_taskController.text);
      _taskController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: 'Enter task name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submitTask(),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: _submitTask,
          child: const Text('Add Task'),
        ),
      ],
    );
  }
} 