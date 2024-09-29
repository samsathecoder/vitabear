import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/chatscreen.dart';
import 'package:vitabearsiparishatti/orderpages/addneworder.dart';
import 'package:vitabearsiparishatti/personalnotes.dart';
import 'package:vitabearsiparishatti/specialprice.dart';
import 'package:vitabearsiparishatti/tabbarviews/dashboard.dart';
import 'package:vitabearsiparishatti/tabbarviews/personalpage.dart';
import 'package:vitabearsiparishatti/uprimhesap.dart';

import 'myallorderstotal.dart';


    class mainmenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>_mainmenuState();




    }
     class _mainmenuState extends State<mainmenu>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Sipariş Gönder", Icons.send, () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewOrder()))),
            makeDashboardItem("Satışlarım Raporu", Icons.book, () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllOrdersTotal()))),
            makeDashboardItem("Firma ile iletişim", Icons.mail, () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()))),
            makeDashboardItem("Siparişlerimi Listele", Icons.list, () =>Navigator.push(context, MaterialPageRoute(builder: (context) => dasboardtabscreen()))),
            makeDashboardItem("kişisel Notlarım", Icons.note, () => Navigator.push(context, MaterialPageRoute(builder: (context) => PersonalNotes()))),
            makeDashboardItem("Uzman Prim Hesapla", Icons.calculate, () => Navigator.push(context, MaterialPageRoute(builder: (context) => UzmanPrim()))),

          ],
        ),
      ),
    );
  }

  Card makeDashboardItem(String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: Colors.white70,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Adjust the border radius as needed
        side: BorderSide(
          color: Colors.white70, // Set the border color here
          width: 2.0, // Set the border width here
        ),
      ),
      margin: EdgeInsets.all(8.0),
      child: Container(
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Text(title,
                    style: TextStyle(fontSize: 18.0, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
     }