import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/classes/products.dart';
import 'package:vitabearsiparishatti/orderpages/addneworder.dart';

enum uzmanprim{uygula,uygulama}
enum iskonto{uygula,uygulama}

enum boxadet{box,adet}
enum status {aktif, pasif, kargoda}
class OrderVals{
bool ivar=false;
bool pvar=false;
  var products=Products();
  bool eczisim = true;
  bool eczisimediting = false;
  int q = 0;
  int mf=0;
int maxValue=0;

List<int> maxadet=[];
void syncData(){
  sumUsingLoop();
malfazlasi();
   ivar?  iskontohesap():products.iskontolu=0;
pvar? uzmanprimhesap():products.prim=0;
total();

}
 /** void _orderdt(String status){
    _sendOrder(status);


  }**/
  void sumUsingLoop() {

    products.maltoplam = 0;
    for (int maltoplam in Products().params1.values) {
      products.maltoplam += maltoplam;
    }
  }
  kdvhesap(){
    products.kdv = products.net * 0.01; // Assuming 18% VAT
    return products.kdv;
  }

  double total() {
    double tkdv;
    // Ensure total is initialized and used correctly
    products.net = products.maltoplam.toDouble();
    double toplamisk = products.iskontolu + products.prim;
    if(toplamisk!=0){
      products.net-=toplamisk;
    }
    products.total = products.net;
    products.total += products.kdv;

    kdvhesap();
    tkdv=products.kdv;
    products.total+=tkdv;
    return products.total;
  }

void malfazlasi() {
  // Initialize variables
  if (q < 11) {
    products.mf = 0;
  }

  int count = 0;
  int tq = 0;
  List<int> sayac = [];
  int lastnumber = 0;
  maxadet.clear(); // Clear maxadet to avoid retaining previous values
  int? maxValue;

  // Calculate total quantity and populate maxadet
  for (int adet in products.adets.values) {
    maxadet.add(adet);
    tq += adet;
  }

  // Calculate count based on total quantity
  for (int i = 12; i <= tq; i += 12) {
    sayac.add(i);
    if (sayac.last % 6 == 0) {
      lastnumber = i;
      count++;

      lastnumber=count;


      }
    }


  // Determine the maximum value in maxadet
  for (var value in maxadet) {
    if (value is int) {
      if (maxValue == null || value > maxValue!) {
        maxValue = value;
      }
    }
  }

  // Update product quantities
  if (maxValue != null && maxValue > 1) {
    products.adets.forEach((key, value) {

        int guncel = value- count;
        products.adets.update(key, (v) => guncel > 0 ? guncel : 0); // Prevent negative values
        print('Updated $key to $guncel');

    });
  }

  // Set mf count
  products.mf = count;
  maxValue = 0; // Reset maxValue for future calls
}


  void iskontohesap() {
    double iskontotutar = 0;
    double iskontotutar5 = 0;
    for (int adet in products.adets.values) {
      q += adet;
    }
    if (  q >= 0 || q <= 18) {
      iskontotutar = (products.maltoplam * 5 / 100);
      products.iskontolu = iskontotutar;
    }
    if ( q >= 36 ) {
      iskontotutar = (products.maltoplam * 5 / 100);
      iskontotutar5 = (products.net * 5 / 100);
    }

    products.iskontolu = iskontotutar + iskontotutar5;
  }

  void uzmanprimhesap() {
    List<int> a = [];
    List<int> b = [];
    var son1 = 0.0, son = 0.0;


      products.adets.forEach((key, value) {
        if (key == Products.vds0004.keys.first || key == Products.vds0005.keys.first) {
          a.add(value);
        }
      });

      for (int n in a) {
        son1 += n * 40;
      }

      products.adets.forEach((key, value) {
        if (key == Products.vds0001.keys.first ||
            key == Products.vds0002.keys.first ||
            key == Products.vds0003.keys.first) {
          b.add(value);
        }
      });

      for (int n in b) {
        son += n * 35;
      }
print("srtsrr$son1/n gdfgdg $son ${products.adets} ");
      products.prim = son1 + son;
      son1=0;
      son=0;
    }


  }
