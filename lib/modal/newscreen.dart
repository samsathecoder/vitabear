import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/modal/task.dart';
import 'package:vitabearsiparishatti/modal/tasktype.dart';
import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/tabbarviews/personalpage.dart';
import 'task.dart';
import 'tasktype.dart';
class NewScreen extends StatefulWidget {
  const NewScreen({super.key, required void Function(Task newTask) addNewTask});

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TaskRepository _taskRepository = TaskRepository();

  TaskType _taskType = TaskType.note;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
        ),

      );
      return;
    }

    final Task newTask = Task(
      id: '', // Firebase will generate this automatically
      type: _taskType,
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: false,
      date: _dateController.text,
      time: _timeController.text,
    );

    await _taskRepository.addTask(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Program ekle",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => (Navigator.push(context, MaterialPageRoute(builder: (context) => Personalpage())))
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Başlık",
                style: TextStyle(fontSize: 16),
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tarih"),
                        TextField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Saat"),
                        TextField(
                          controller: _timeController,
                          readOnly: true,
                          onTap: () => _selectTime(context),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Detay",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 150,
                child: TextField(
                  controller: _descriptionController,
                  expands: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTask,
                child: const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      _timeController.text = selectedTime.format(context);
    }
  }
}

class TaskRepository {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("tasks");

  // Add a new task to Firebase
  Future<void> addTask(Task task) async {
    try {
      final taskRef = _dbRef.push(); // Generate a new unique ID
      await taskRef.set(task.toMap()); // Save the task to Firebase
    } catch (e) {
      print('Error adding task: $e');
      // Handle error appropriately
    }
  }

// You can add more methods here for reading/updating/deleting tasks
}
