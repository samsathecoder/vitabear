import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase
import 'newscreen.dart';
import 'task.dart'; // Import your Task model
import 'tasktype.dart'; // Import TaskType if needed

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _todoTasks = [];
  final List<Task> _completedTasks = [];
  final DatabaseReference _taskRef = FirebaseDatabase.instance.ref().child('tasks');

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    _taskRef.onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final List<Task> tasks = data.entries.map((entry) {
          final task = Task.fromMap(Map<String, dynamic>.from(entry.value));
          return task;
        }).toList();

        setState(() {
          _todoTasks.clear();
          _completedTasks.clear();
          for (var task in tasks) {
            if (task.isCompleted) {
              _completedTasks.add(task);
            } else {
              _todoTasks.add(task);
            }
          }
        });
      }
    });
  }

  void _addNewTask(Task newTask) {
    _taskRef.push().set(newTask.toMap()).then((_) {
      setState(() {
        if (newTask.isCompleted) {
          _completedTasks.add(newTask);
        } else {
          _todoTasks.add(newTask);
        }
      });
    }).catchError((error) {
      print('Error adding task: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Todo Tasks
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yapılacaklar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(

                    child: ListView.builder(
                      itemCount: _todoTasks.length,
                      itemBuilder: (context, index) {
                        final task = _todoTasks[index];
                        return ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: Checkbox(
                            value: task.isCompleted,
                            onChanged: (bool? value) {
                              setState(() {
                                task.isCompleted = value ?? false;
                                _updateTask(task);
                                _todoTasks.removeAt(index);
                                _completedTasks.add(task);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Completed Tasks
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tamamlananlar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _completedTasks.length,
                      itemBuilder: (context, index) {
                        final task = _completedTasks[index];
                        return ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: Checkbox(
                            value: task.isCompleted,
                            onChanged: (bool? value) {
                              setState(() {
                                task.isCompleted = value ?? false;
                                _updateTask(task);
                                _completedTasks.removeAt(index);
                                _todoTasks.add(task);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewScreen(
                    addNewTask: _addNewTask,
                  ),
                ),
              );
            },
            child: const Text('Yeni plan ekle'),
          ),
        ],
      ),
    );
  }

  void _updateTask(Task task) {
    _taskRef.child(task.id).update(task.toMap()).catchError((error) {
      print('Error updating task: $error');
    });
  }
}
