import 'dart:core';

class Products{
  static final Products _instance = Products.internal();

  static late var deneme = {"strong Hair": 484};
  static late var vds0001 = {"strong Hair": 484};
  static late var vds0002 = {"sleepy bear": 491};
  static late var vds0003 = {"beautiful bear": 484};
  static late var vds0004 = {"relax bear": 638};
  static late var vds0005 = {"hair plus bear": 571};
    int box = 6;
   int value=0;

   String quantity="0";
int maltoplam=0;
    late var total=0.0, prim=0.0, iskontolu=0.0,net=0.0,kdv=0.0;

  // Mapping each map key to an integer value
  Map params = {
  vds0001.keys.first: vds0001.values.last,
  vds0002.keys.first: vds0002.values.last,
  vds0003.keys.first: vds0003.values.last,
  vds0004.keys.first: vds0004.values.last,
  vds0005.keys.first: vds0005.values.last
  };

  Map params1={} ;
  Map adets   ={};
  Map data = {} ;
  int mf=0;

  factory Products() {
    return _instance;
  }

  Products.internal() {
    Map<String,int> params1 ;
    Map adets   ={};
    Map data = {} ;  mf;}

  // Function to return a set containing the keys of the maps
  Set<String> toMap() {
  return {
  vds0001.keys.first.toString(),
  vds0002.keys.first.toString(),
  vds0003.keys.first.toString(),
  vds0004.keys.first.toString(),
  vds0005.keys.first.toString(),
  }
  ;
  }
  }





