import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/modal/tasktype.dart';
import '../modal/newscreen.dart';
import '../modal/showtask.dart';
import '../modal/task.dart';
import 'package:firebase_core/firebase_core.dart';

const String primaryColor = "#525FE1";
const String secondaryColor = "#F86F03";
const String backgroundColor = "#F1F5F9";

class Personalpage extends StatefulWidget {
  late final void Function(Task newTask) addNewTask;

  // Passing function as parameter

  @override
  State<Personalpage> createState() => _PersonalpageState();
}

class _PersonalpageState extends State<Personalpage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
   // Number of tabs


        body:
             // Widget for Active Orders
            TaskListScreen(),
            // Widget for Processing Orders


      );








        /**Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "October 20, 2022",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "My Todo List",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),



            // Top Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: todo.length,
                    itemBuilder: (context, index) {
                      return TodoItem();
                    },
                  ),
                ),
              ),
            ),
            // Completed Text
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Completed",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            // Bottom Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: completed.length,
                    itemBuilder: (context, index) {
                      return TodoItem();
                    },
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const NewScreen();
                  },
                ));
              },
              child: const Text("Add New Task"),
            )
          ],
        ),**/
  }
}