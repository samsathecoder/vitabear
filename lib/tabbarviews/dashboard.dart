import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/classes/ordervals.dart';
import 'package:vitabearsiparishatti/classes/products.dart';
import 'package:vitabearsiparishatti/mainscreen.dart';
import 'package:vitabearsiparishatti/orderpages/waitingorders.dart';
import 'package:vitabearsiparishatti/orderpages/unsendingorders.dart';
import 'package:vitabearsiparishatti/dbhelper/_fetchData.dart';
class dasboardtabscreen extends StatefulWidget{
  const dasboardtabscreen({super.key});

  @override
 State<StatefulWidget> createState() => _DashboardtabscreenState();

}

class _DashboardtabscreenState extends State<dasboardtabscreen>  {
  Products products = Products();
  Map orderitems = {};

  late int length = 0;
  Map<String, Map<String, dynamic>> data = {};

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar( backgroundColor: Colors.white24,
          title: Text("Tüm Siparişlerim"),
          bottom: TabBar(
            labelColor: Colors.blueGrey,
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(text: 'Aktif siparişler'),
              Tab(text: 'Bekleyenler'),
              Tab(text: 'Taslak'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: TabBarView(
            children: [
              ActiveOrders(), // Widget for Active Orders
              WaitingOrders(), // Widget for Waiting Orders
              unsendingOrders(), // Widget for Unsending Orders
            ],
          ),
        ),
      ),
    );
  }
}
  Widget _tabbar(){
    return DefaultTabController(length: 3, child:
    SafeArea(
      child: Column(
        children: <Widget>[ new Row(   children: [SizedBox(width: 100,),
          new Center(child:Text("Tüm Siparişlerim",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),],),
          new Expanded(child: new Container()),
          const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs:  [
              Tab(text: 'Aktif siparişler'),
              Tab(text: 'bekleyenler'),
              Tab(text: 'taslak'),
            ],
          ),
        ],
      ),
    ),

    );


  }


  class ActiveOrders extends StatefulWidget {

  @override
  _ActiveOrdersState createState() => _ActiveOrdersState();
  }

  class _ActiveOrdersState extends State<ActiveOrders>   {
    Map<String, Map<String, dynamic>> data = {};
  String Mauth = FirebaseAuth.instance.currentUser!.uid;
  late bool _isLoading = true;
    @override
  void initState() {
      String currentStatus = "aktif"; // Set your status here

    super.initState();
    OrderVals prd= OrderVals();
  DatabaseHelper().fetchData(currentStatus,(newData) {

    setState(() {
      data = newData;
    });
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _orderlist());
  }
Widget _orderlist(){
     return ListView.builder(
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
     );


}


  }

