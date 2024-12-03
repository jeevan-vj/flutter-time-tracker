import 'package:flutter/material.dart';
import '../models/project.dart';

class ProjectProvider extends ChangeNotifier {
  final List<Project> _projects = [
    Project(id: '1', name: 'Mobile App', color: Colors.blue),
    Project(id: '2', name: 'Backend', color: Colors.purple),
    Project(id: '3', name: 'Development', color: Colors.orange),
    Project(id: '4', name: 'Management', color: Colors.green),
  ];

  List<Project> get projects => List.unmodifiable(_projects);

  void addProject(String name, Color color) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _projects.add(Project(id: id, name: name, color: color));
    notifyListeners();
  }
} 