import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/classes/products.dart';
import 'package:vitabearsiparishatti/orderpages/addneworder.dart';
import 'classes/ordervals.dart';

enum SingingCharacter { adet, box }

class SpecialPriceOrder extends StatefulWidget {
  @override
  _SpecialPriceOrder createState() => _SpecialPriceOrder();
}

class _SpecialPriceOrder extends State<SpecialPriceOrder> {
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final _pharmacyController = TextEditingController();

  SingingCharacter? _character = SingingCharacter.adet;
  var orderprocess = OrderVals();
  final products = Products();
  final user = FirebaseAuth.instance.currentUser;
  String selectedValue = Products().toMap().first;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Özel fiyat ile gönder"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product selection
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            const Text("Eczane ismi:", style: TextStyle(fontSize: 16)),
            SizedBox(width: 30,),
            Expanded(
              child: TextField(
                onEditingComplete: () => dispose,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
                controller: _pharmacyController ,
                decoration:  InputDecoration( labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  hintText: 'Eczane ismini giriniz',
                  border: InputBorder.none,

                ),
              ),
            ),
          ],
        ),
            Row(
              children: [
                const Text("Sipariş ürün seçiniz:", style: TextStyle(fontSize: 16)),
                Expanded(
                  child: DropdownButton<String>(
                    alignment: Alignment.center,
                    items: products.toMap()
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
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
            SizedBox(height: 10),

            // Quantity selection
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
            SizedBox(height: 10),

            // Quantity input
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Adet giriniz',
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),

            // Price input
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Fiyat giriniz',
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),

            // Add item button
            ElevatedButton(
              onPressed: () {
                int? price = int.tryParse(priceController.text);
                if (quantityController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  addItem(price!);
                  setState(() {});
                }
              },
              child: const Text("Onayla"),
            ),
            SizedBox(height: 10),

            // Product list
            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => const Divider(color: Colors.grey),
              itemCount: products.params1.length,
              itemBuilder: (context, index) {
                var key = products.params1.keys.elementAt(index);
                var value = products.params1.values.elementAt(index);
                return ListTile(
                  leading: const Icon(Icons.plus_one),
                  title: Text("${key} Adeti: ${products.adets[key] ?? '0'}"),
                  trailing: Container(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Fiyatı: ${value}"),
                        IconButton(
                          icon: const Icon(Icons.remove_circle),
                          onPressed: () {
                            setState(() {
                              products.params1.remove(key);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            // Feedback field
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Sipariş için ekstralarınızı buraya yazabilirsiniz...',
              ),
            ),
            SizedBox(height: 10),

            // Order action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _orderdt("taslak"),
                  child: const Text("Taslak olarak kaydet"),
                ),
                ElevatedButton(
                  onPressed: () => _orderdt("bekleyen"),
                  child: const Text("Firmaya Gönder"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _orderdt(String status) {
    _sendOrder(status);
  }

  Future<void> _sendOrder(String status) async {
    final eczane = _pharmacyController.text;

    if (eczane.isNotEmpty) {
      final ref = FirebaseDatabase.instance.ref("${user!.uid}/siparis").child(eczane);
      ref.set({
        "ürünler": products.params1,
        "adedi": products.adets,
        "notlar": _feedbackController.text,
        "status": status,
        "createddate": getCurrentDate(),
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Siparişiniz firmaya gönderildi')),
        );
        products.params1.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sipariş gönderilemedi: $error')),
        );
      });
    } else {
      // Show error dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Eczane ismini giriniz.')),
      );
    }
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String day = now.day.toString().padLeft(2, '0');
    String month = now.month.toString().padLeft(2, '0');
    String year = now.year.toString();

    return '$day-$month-$year';
  }

  void addItem(int price) {
    final quantity = int.tryParse(quantityController.text) ?? 0;
    if (quantity > 0) {
      for (var entry in products.params.entries) {
        if (entry.key == selectedValue) {
          products.value = price;
          if (_character == SingingCharacter.box) {
            int adet = quantity * 6;
            products.params1[selectedValue] = products.value * adet;
            products.adets[selectedValue] = adet;
          } else {
            products.params1[selectedValue] = products.value * quantity;
            products.adets[selectedValue] = quantity;
          }

          products.value = 0;
          quantityController.clear();
          priceController.clear(); // Clear price input
          setState(() {});
        }
      }
    } else {
      // Show error dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adet giriniz.')),
      );
    }
  }
}
