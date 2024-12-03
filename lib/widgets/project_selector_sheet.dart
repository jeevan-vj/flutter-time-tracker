import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';

class ProjectSelectorSheet extends StatelessWidget {
  final Function(Project) onProjectSelected;

  const ProjectSelectorSheet({
    super.key,
    required this.onProjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Project',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<ProjectProvider>(
            builder: (context, projectProvider, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: projectProvider.projects.length + 1,
                itemBuilder: (context, index) {
                  if (index == projectProvider.projects.length) {
                    return ListTile(
                      leading: const Icon(Icons.add, color: Color(0xFFE371AA)),
                      title: const Text(
                        'Create New Project',
                        style: TextStyle(color: Color(0xFFE371AA)),
                      ),
                      onTap: () {
                        // Show create project dialog
                        _showCreateProjectDialog(context);
                      },
                    );
                  }

                  final project = projectProvider.projects[index];
                  return ListTile(
                    leading: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: project.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(
                      project.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () => onProjectSelected(project),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCreateProjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2C31),
        title: const Text(
          'Create Project',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Project name',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<ProjectProvider>().addProject(
                      nameController.text,
                      Colors.primaries[
                          DateTime.now().millisecond % Colors.primaries.length],
                    );
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Create',
              style: TextStyle(color: Color(0xFFE371AA)),
            ),
          ),
        ],
      ),
    );
  }
} 