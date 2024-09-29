
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dbhelper/_fetchData.dart';

class WaitingOrders extends StatefulWidget {
  @override
  _WaitingOrdersState createState() => _WaitingOrdersState();
}

class _WaitingOrdersState extends State<WaitingOrders> {
  Map<String, Map<String, dynamic>> data = {};
  late bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    String currentStatus = "bekleyen"; // Set your status here

    super.initState();
    DatabaseHelper().fetchData(currentStatus,(newData) {

      setState(() {
        data = newData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final entry = data.entries.toList()[index];
          final key = entry.key;
          final orderItems = entry.value;

          return Card(
            elevation: 5, // Adjust the elevation as needed
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust margins as needed
            child: ExpansionTile(
              title: Text(key),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: orderItems.entries.map((orderItem) {
                      final subKey = orderItem.key;
                      final subValue = orderItem.value;
                      return Text('$subKey: $subValue');
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}