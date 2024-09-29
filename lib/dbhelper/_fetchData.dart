
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vitabearsiparishatti/classes/ordervals.dart';
import 'package:vitabearsiparishatti/home_screen.dart';
class firebaseval  {


  String Mauth = FirebaseAuth.instance.currentUser!.uid;
}

class DatabaseHelper {
  firebaseval value = firebaseval();
  Map? ordermap;

  Future<void> sendordderfromdraft(String eczismi) async {
    final db = FirebaseDatabase.instance.ref("${value.Mauth}/siparis/$eczismi");
    db.onValue.listen((onData) async {
      if (onData.snapshot.exists
      ) {
        await db.update({
          'status': 'bekleyen',
          // You can add more keys to update
        }).then((_) {
          print('Data updated successfully.');
        }).catchError((error) {
          print('Failed to update data: $error');
        });
      }
    });
  }

  void orderstotal() {
    int total = 0;
    if (ordermap?.keys == "strong hair") {
      // Iterate over the values associated with "key1"
      for (int va in ordermap?["strong hair"]) {
        print(total += va); // Accumulate the total
      }
    }
  }




  Future<int> allorderstotal(String selectedValue) async {
    final db = FirebaseDatabase.instance.ref("${value.Mauth}/siparis");
    int totalStrongHair = 0;

    // Use a completer to handle asynchronous completion
    final completer = Completer<int>();

    db.onValue.listen((onData) {
      try {
        final firstMap = onData.snapshot.value as Map;

        firstMap.forEach((k, v) {
          final infoData = v as Map;
          final orderMap = infoData["adedi"] as Map<dynamic, dynamic>?;

          if (orderMap != null && orderMap.containsKey(selectedValue)) {
            var strongHairValue = orderMap[selectedValue];

            // Debugging line
            print("Found strong hair value: $strongHairValue");

            // Directly check if it's an int and accumulate
            if (strongHairValue is int) {
              totalStrongHair += strongHairValue; // Accumulate the total
            } else {
              print("Strong hair value is not an int: $strongHairValue"); // Debugging line
            }
          } else {
            print("Order map is null or does not contain '$selectedValue'."); // Debugging line
          }
        });

        // Complete the future with the total
        print('Total for strong hair: $totalStrongHair'); // Output the total
        completer.complete(totalStrongHair);
      } catch (e) {
        print("Error: $e");
        completer.completeError(e);
      }
    });

    return completer.future; // Return the future
  }
  Future<void> fetchData(String status, Function(Map<String, Map<String, dynamic>>) onDataFetched) async {
    final db = FirebaseDatabase.instance.ref("${value.Mauth}/siparis");

    db.onValue.listen((onData) {
      try {
        final firstMap = onData.snapshot.value as Map<dynamic, dynamic>?;
        print("firstMap: $firstMap");

        if (firstMap != null) {
          final newData = <String, Map<String, dynamic>>{};
          firstMap.forEach((k, v) {
            final infoData = v as Map<dynamic, dynamic>?;

            if (infoData != null && infoData.values.contains(status)) {
              final orderItems = <String, dynamic>{};

              infoData.forEach((sk, sv) {
                if (sk == "adedi") {
                  final orderMap = sv as Map<dynamic, dynamic>?;

                  if (orderMap != null) {
                    orderItems.addAll(orderMap.cast<String, dynamic>());
                  }
                }
              });

              newData[k.toString()] = orderItems;
            }
          });

          // Call the callback with the new data
          onDataFetched(newData);
        }
      } catch (e) {
        print('Error fetching data: $e');
      }
    });
  }
}
