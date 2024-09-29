import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/dbhelper/_fetchData.dart';

import 'classes/products.dart';

class AllOrdersTotal extends StatefulWidget{

  _AllOrdersTotalState createState()=> _AllOrdersTotalState();

}

class _AllOrdersTotalState extends State<AllOrdersTotal>{
  @override
  void initState() {
    super.initState();
    _fetchTotalOrders();

  }
  int _result = 0;
  bool _loading = true;
  Future<void> _fetchTotalOrders() async {
    try {
      final total = await DatabaseHelper().allorderstotal(selectedValue);
      setState(() {
        _result = total;
        _loading = false;
      });
    } catch (e) {
      // Handle any errors here
      print("Error fetching total orders: $e");
      setState(() {
        _loading = false;
      });
    }
  }
  String? selectedProduct;
  final products = Products();
  String selectedValue = Products().toMap().first;
  @override
  Widget build(BuildContext context)    {
    return Scaffold(
      appBar: AppBar(title: Text("Sipariş adet toplamı")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                "Tüm Siparişlerim Toplamı",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
Center( child:
            // Label and Dropdown Button
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Görmek istediğiniz ürünü seçiniz:",
                  style: TextStyle(fontSize: 18),
                ),
                DropdownButton<String>(alignment: Alignment.center,
                  hint: Text("ürün seçiniz"),
                  items: products.toMap()
                      .map((e) => DropdownMenuItem(  value: e, child: Text(e,textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold, ),)))
                      .toList(),
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;});
_fetchTotalOrders();
                  },
                ),
                Divider(),

                Text(

                  'Adet Bazında Satılan: $_result',

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
            // Card with Column
            AnimatedOpacity(
              opacity: selectedProduct != null ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(

                       'Total Orders: $_result',

                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),),
          ],
        ),
      ),
    );
  }
}