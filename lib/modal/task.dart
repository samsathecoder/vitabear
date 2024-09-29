import 'package:vitabearsiparishatti/modal/tasktype.dart';
class Task {
  final String id; // Add an id to uniquely identify each task
  final TaskType type;
  final String title;
  final String description;
  late final bool isCompleted;
  final String? date;
  final String? time;

  Task({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.isCompleted,
    this.date,
    this.time,
  });

  // Convert a Task into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'date': date,
      'time': time,
    };
  }

  // Create a Task from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      type: TaskType.values.firstWhere((e) => e.toString() == map['type']),
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      date: map['date'],
      time: map['time'],
    );
  }
}