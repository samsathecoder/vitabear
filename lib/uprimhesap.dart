import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/classes/products.dart';
import 'package:vitabearsiparishatti/classes/ordervals.dart';

enum SingingCharacter { adet, box }

class UzmanPrim extends StatefulWidget {
  @override
  _UzmanPrimState createState() => _UzmanPrimState();
}

class _UzmanPrimState extends State<UzmanPrim> {
  final quantityController = TextEditingController();
  SingingCharacter? _character = SingingCharacter.adet;
  final orderProcess = OrderVals();
  final products = Products();
  String selectedValue = Products().toMap().first;
  double totalPrim = 0; // State variable to hold the total
String error=" seçili ürüne değer girilmiş";
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    products.prim=0;
    products.total=0;
    products.params1.clear();
    products.adets.clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uzman Prim Hesapla"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text("Sipariş ürün seçiniz:", style: TextStyle(fontSize: 16)),
                Expanded(
                  child: DropdownButton<String>(
                    alignment: Alignment.center,
                    items: products.toMap()
                        .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontWeight: FontWeight.bold))))
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Miktar seçiniz:", style: TextStyle(fontSize: 16)),
                Flexible(
                  child: RadioListTile<SingingCharacter>(
                    title: const Text('Adet'),
                    value: SingingCharacter.adet,
                    groupValue: _character,
                    onChanged: (SingingCharacter? adet) {
                      setState(() {
                        _character = adet;
                      });
                    },
                  ),
                ),
                Flexible(
                  child: RadioListTile<SingingCharacter>(
                    title: const Text('Box'),
                    value: SingingCharacter.box,
                    groupValue: _character,
                    onChanged: (SingingCharacter? box) {
                      setState(() {
                        _character = box;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Adet giriniz',
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  tooltip: "Yeni Ürün Ekle",
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (quantityController.text.isNotEmpty) {
                      addItem();
                    } else {
                      SnackBar(
                          content: Text(error),
                    duration: Duration(seconds: 2));
                    }
                  },
                ),
              ],
            ),
            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => const Divider(color: Colors.grey),
              itemCount: products.params1.length,
              itemBuilder: (context, index) {
                var key = products.params1.keys.elementAt(index);
                return ListTile(
                  leading: const Icon(Icons.plus_one),
                  title: Text("${key} Adeti: ${products.adets[key] ?? '0'}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        products.params1.remove(key);
                        products.adets.remove(key);
                      });
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: calculateTotal, child: Text("Hesapla")),
            Text("Toplam verilecek uzman prim: $totalPrim"), // Displaying the calculated total
          ],
        ),
      ),
    );
  }

  void addItem() {
    final quantity = int.tryParse(quantityController.text) ?? 0;
    if (quantity > 0 && !products.params1.containsKey(selectedValue)) {
      for (var entry in products.params.entries) {
        if (entry.key == selectedValue) {
          products.value = entry.value;
          int adet = (_character == SingingCharacter.box) ? quantity * 6 : quantity;

products.params1.containsKey(selectedValue)?    print("değer girilmiş")   :products.params1[selectedValue] = products.value * adet;
          products.adets[selectedValue] = adet;

          quantityController.clear();
          setState(() {
            calculateTotal();
          });
        }
      }
    } else {
     errorm();}
  }
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorm() {
   return
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error),
      duration: Duration(seconds: 2), // Duration for which the SnackBar is visible

      ));




}
  void calculateTotal() {
    products.prim=0;
    totalPrim=0;
    orderProcess.uzmanprimhesap();
    setState(() {
      totalPrim = products.prim; // Store the calculated total
    });
  }
}
