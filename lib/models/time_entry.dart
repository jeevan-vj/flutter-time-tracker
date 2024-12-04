class TimeEntry {
  final String id;
  final String description;
  final String project;
  final DateTime startTime;
  final DateTime endTime;
  final bool isRunning;

  TimeEntry({
    required this.id,
    required this.description,
    required this.project,
    required this.startTime,
    required this.endTime,
    this.isRunning = false,
  });

  Duration get duration => endTime.difference(startTime);

  // Create a copy of the time entry with updated fields
  TimeEntry copyWith({
    String? id,
    String? description,
    String? project,
    DateTime? startTime,
    DateTime? endTime,
    bool? isRunning,
  }) {
    return TimeEntry(
      id: id ?? this.id,
      description: description ?? this.description,
      project: project ?? this.project,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  // Convert to and from JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'project': project,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isRunning': isRunning,
    };
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'] as String,
      description: json['description'] as String,
      project: json['project'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      isRunning: json['isRunning'] as bool? ?? false,
    );
  }
}
