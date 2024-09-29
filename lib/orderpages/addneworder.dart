import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/classes/products.dart';
import 'package:vitabearsiparishatti/classes/ordervals.dart';
import 'package:vitabearsiparishatti/home_screen.dart';
import 'package:vitabearsiparishatti/mainscreen.dart';
import 'package:vitabearsiparishatti/specialprice.dart';
import 'package:vitabearsiparishatti/tabbarviews/dashboard.dart';

enum SingingCharacter { adet, box }
enum iskonto { uygula, uygulama }
enum uzmanprim { uygula, uygulama }


class AddNewOrder extends StatefulWidget {
  const AddNewOrder({super.key});

  @override
  State<StatefulWidget> createState() => _AddNewOrderState();

}

class _AddNewOrderState extends State<AddNewOrder> with SingleTickerProviderStateMixin {
late TabController _tabController;
bool _isTabSelected = false; // Track if a tab is selected

final user = FirebaseAuth.instance.currentUser;
FirebaseDatabase database = FirebaseDatabase.instance;
OrderVals vars = OrderVals();
final products = Products();
String selectedValue = Products().toMap().first;
final TextEditingController _quantityController  = TextEditingController();
final TextEditingController _pharmacyController = TextEditingController();
final TextEditingController _feedbackController =TextEditingController();
SingingCharacter? _character = SingingCharacter.adet;
iskonto? _secilen = iskonto.uygulama;
uzmanprim? _uzmsecilen = uzmanprim.uygulama;
late FocusNode _focusNode;
var orderprocess = OrderVals();

@override
void initState() {
  super.initState();
  _tabController = TabController(length: 2, vsync: this);
  orderprocess.syncData();
  products.mf=0;products.prim=0;products.maltoplam=0;
  products.params1.clear();
 // products.params.clear();
  products.kdv=0;
  products.iskontolu=0;
  products.net=0;
  products.total=0;
  products.quantity="0";
  products.box=0;
  products.adets.clear();
}

@override
void dispose() {

  super.dispose();
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!_isTabSelected) // Show cards only if no tab is selected
          _ordertype(),
        if (_isTabSelected) // Show TabBarView only if a tab is selected
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCurrentOrderWidget(),
SpecialPriceOrder()              ],
            ),
          ),
      ],
    ),
  );
}

Widget _ordertype() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildOrderCard('Normal Satış', 0),
        const SizedBox(width: 16),
        _buildOrderCard('Özel Fiyat ile Satış', 1),
      ],
    ),
  );
}

Widget _buildOrderCard(String title, int index) {
  return SizedBox(
    height: 100,
    width: 150,
    child: Card(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          setState(() {
            _isTabSelected = true; // Mark that a tab has been selected
          });
          _tabController.animateTo(index);
        },
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    ),
  );
}

Widget _buildCurrentOrderWidget() {
  return Scaffold(

    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPharmacyField(),
          const Divider(color: Colors.grey),
          _buildProductDropdown(),
          const Divider(color: Colors.grey),
          _buildQuantityField(),
          const Divider(color: Colors.grey),
          _buildMeasurementChoice(),
          const Divider(color: Colors.grey),
          _buildDiscountChoice(),
          _buildExpertBonusChoice(),
          const Divider(color: Colors.grey),
          Text("Ürünler",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold  ,height: 3 ),),
          _buildProductList(),
          const Divider(color: Colors.grey),
          _feedback(),
          const Divider(color: Colors.grey),
          _buildSummary(),
          const Divider(color: Colors.grey),
          _buttons(),
        ],
      ),
    ),
  );
}

Widget _feedback() {
  return TextField(
    controller: _feedbackController,
    maxLines: 5,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      hintText: 'Sipariş için ekstralarınızı buraya yazabilirsiniz...',
    ),
  );
}

Widget _buildPharmacyField() {
  return Row(
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
  );
}

Widget _buildProductDropdown() {
  return Row(
    children: [
      const Text("Sipariş ürün seçiniz:", style: TextStyle(fontSize: 16)),
      Expanded(

        child: Center(heightFactor: 1, child:  DropdownButton<String>(alignment: Alignment.center,
          items: products.toMap()
              .map((e) => DropdownMenuItem(  value: e, child: Text(e,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, ),)))
              .toList(),
          value: selectedValue,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
          },
        ),
      ),),
    ],
  );
}

Widget _buildQuantityField() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        flex: 2,
        child: TextField(
          controller: _quantityController,
          decoration:  InputDecoration(
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
          if (_quantityController.text.isNotEmpty) {
            setState(() {
              addItem();
              orderprocess.syncData();
            });
          } else {
            _showAlertDialog("Hata", "Adet giriniz.");
          }
        },
      ),
    ],
  );
}

Widget _buildMeasurementChoice() {
  return Row(    crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically in the center
mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      const Text("Miktar seçiniz:", style: TextStyle(fontSize: 16)),
      Flexible(flex: 3,
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
      Flexible(flex: 3,
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
  );
}

Widget _buildDiscountChoice() {
  return Row(    crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically in the center

    children: [
      const Text("İskonto:", style: TextStyle(fontSize: 16)),
      Expanded(
        child: RadioListTile<iskonto>(
          title: const Text('var'),
          value: iskonto.uygula,
          groupValue: _secilen,
          onChanged: (iskonto? value) {
            setState(() {
              _secilen = value;
              orderprocess.ivar = true;
              orderprocess.syncData();
            });
          },
        ),
      ),
      Expanded(
        child: RadioListTile<iskonto>(
          title: const Text('yok'),
          value: iskonto.uygulama,
          groupValue: _secilen,
          onChanged: (iskonto? value) {
            setState(() {
              _secilen = value;
              orderprocess.ivar = false;
              orderprocess.syncData();
            });
          },
        ),
      ),
    ],
  );
}

Widget _buildExpertBonusChoice() {
  return Row(    crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically in the center

    children: [
      const Text("Uzman Prim:", style: TextStyle(fontSize: 16)),
      Expanded(
        child: RadioListTile<uzmanprim>(
          title: const Text('var'),
          value: uzmanprim.uygula,
          groupValue: _uzmsecilen,
          onChanged: (uzmanprim? value) {
            setState(() {
              _uzmsecilen = value;
              orderprocess.pvar = true;
              orderprocess.syncData();
            });
          },
        ),
      ),
      Expanded(
        child: RadioListTile<uzmanprim>(
          title: const Text('yok'),
          value: uzmanprim.uygulama,
          groupValue: _uzmsecilen,
          onChanged: (uzmanprim? value) {
            setState(() {
              _uzmsecilen = value;
              orderprocess.pvar = false;
              orderprocess.syncData();
            });
          },
        ),
      ),
    ],
  );
}

Widget _buildProductList() {
  return ListView.separated(
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
  );
}

Widget _buttons() {
  return Row(
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
  );
}

Widget _buildSummary() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Mal Toplamı: ${products.maltoplam}"),
      Text("KDV: ${products.kdv.toStringAsFixed(2)}"),
      Text("İskonto: ${products.iskontolu.toStringAsFixed(2)}"),
      Text("Prim: ${products.prim}"),
      Text("Toplam Tutar: ${products.total.toStringAsFixed(2)}"),
      Text("Verilecek mf adedi: ${products.mf}"),
    ],
  );
}


void addItem() {
  final quantity = int.tryParse(_quantityController.text) ?? 0;
  print(quantity);
  if (quantity > 0) {
    for (var entry in products.params.entries) {
      if (entry.key == selectedValue) {
        products.value = entry.value;
        if (_character == SingingCharacter.box) {
          int adet = quantity * 6;
          products.params1[selectedValue] = products.value * adet;
          products.adets[selectedValue] = adet;
        } else {
          products.params1[selectedValue] = products.value * quantity;
          products.adets[selectedValue] = quantity;
        }

        products.value = 0;
        _quantityController.clear();
        orderprocess.syncData();
        setState(() {
          Products().data.addAll({
            "ürün": Products().params1.keys.toList(),
            "fiyat:adet": {Products().params1.values.toList(), quantity}
          });
        });
orderprocess.sumUsingLoop();      }
    }
  } else {
   _showAlertDialog("Hata", "Adet giriniz.");
  }
}
void _showAlertDialog(String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Tamam"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void _orderdt(String status){
  _sendOrder(status);


}
Future<void> _sendOrder(String status) async {
  final eczane = _pharmacyController.text;

  if (eczane.isNotEmpty) {
    final ref = FirebaseDatabase.instance.ref("${user!.uid}/siparis").child(eczane);
    ref.set({

      "ürünler": products.params1,
      "adedi": products.adets,
      "notlar":_feedbackController.text,
      "status": status,
      "createddate": DateTime.now().toIso8601String(),

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
    _showAlertDialog("Hata", "Eczane ismini giriniz.");
  }
}


  Widget _buildEmptyWidget() {
    return Scaffold(
      appBar: AppBar(title: const Text("Sipariş Gönder"), leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Clear variables when the back button is pressed
          Navigator.pop(context);
        },),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            _buildProductDropdown(),
            const Divider(color: Colors.grey),
            _buildQuantityField(),
            const Divider(color: Colors.grey),
            _buildMeasurementChoice(),
            const Divider(color: Colors.grey),
            Text("Ürünler",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold  ,height: 3 ),),
            _buildProductList(),
            const Divider(color: Colors.grey),
            _feedback(),
            const Divider(color: Colors.grey),
            _buildSummary(),
            const Divider(color: Colors.grey),
            _buttons(),
          ],
        ),
      ),
    );
  }




}

