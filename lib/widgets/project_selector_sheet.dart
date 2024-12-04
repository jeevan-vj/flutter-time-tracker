import 'package:flutter/material.dart';
import '../models/project.dart';

class ProjectSelectorSheet extends StatelessWidget {
  final List<Project> projects;
  final Project? selectedProject;

  const ProjectSelectorSheet({
    super.key,
    required this.projects,
    this.selectedProject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Select Project',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ListTile(
                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: project.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(project.name),
                  selected: project.id == selectedProject?.id,
                  onTap: () => Navigator.pop(context, project),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
