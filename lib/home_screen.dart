import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitabearsiparishatti/mainscreen.dart';
import 'package:vitabearsiparishatti/tabbarviews/dashboard.dart';
import 'package:vitabearsiparishatti/orderpages/addneworder.dart';
import 'package:vitabearsiparishatti/tabbarviews/personalpage.dart';

import 'mainscreen.dart';
import 'mainscreen.dart';
import 'modal/task.dart';







class HomeScreen extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => _HomeScreen();

}


class _HomeScreen extends State<HomeScreen> with TickerProviderStateMixin{

  MotionTabBarController? _motionTabBarController;
    late mainmenu Mainmenu;
    late AddNewOrder addorder;
    late Personalpage personalpage;
    final _auth = FirebaseAuth.instance;



    //using this function you can use the credentials of the user
    void getCurrentUser() async {
    try {
    final user = await _auth.currentUser;
    if (user != null) {
    }
    else{ Navigator.pop(context);}
    } catch (e) {
    print(e);
    }
    }

  @override
  void initState() {
    super.initState();
getCurrentUser();
      Mainmenu =  mainmenu();
      addorder =  const AddNewOrder();
      personalpage =   Personalpage();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3, vsync: this,
    );
  }
  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue[400],
              shadowColor: Colors.transparent,
              elevation: 10.0,
              centerTitle: false,
              scrolledUnderElevation: 1.0,
              toolbarHeight: 60.0,
              titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.normal),
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    // Handle menu selection
                  },

                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                        value: 'Option 1',
                        child: const Text('Portal hakkında'),onTap: () {
                      _motionTabBarController!.index = 3;
                    }


                    ),
                    PopupMenuItem<String>(
                      value: 'Option 2',
                      child: const Text('Çıkış yap'),onTap: () => signout(),
                    ),

                  ],


                ),
              ],
              title: Text(
                "Vitabear Sipariş Hattı",
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              floating: true,
              snap: true,

            ),
          ];
        },
        body:TabBarView(
          physics: const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
          // controller: _tabController,
          controller: _motionTabBarController,
          children: <Widget>[
            Mainmenu,
            addorder,
            personalpage,
          ],
        ),
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController, // ADD THIS if you need to change your tab programmatically
        initialSelectedTab: "Ana Sayfa",
        labels: const ["Ana Sayfa", "Sipariş Gönder","Profilim"],
        icons: const [Icons.dashboard, Icons.add_circle, Icons.person_sharp],

        // optional badges, length must be same with labels

        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.blue[200],
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Colors.blue[400],
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            // _tabController!.index = value;
            _motionTabBarController!.index = value;
          });
        },
      ),
    );








  }




  signout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacementNamed('login');
  }




}

/**Container(

    child: ListView.separated(        // To add separation line between the ListView
    separatorBuilder: (context, index) => const Divider(
    color: Colors.grey
    ),

    itemCount: products.params1.length,

    itemBuilder: (BuildContext context, int index) {
    for (int i = 1; i <= products.params1.length; i++) {
    return ListTile(
    leading: const Icon(Icons.place),
    trailing: Text(
    products.params1.values.elementAt(index).toString()),
    title: Text(
    products.params1.keys.elementAt(index).toString()),
    );
    }
    }
    ),
    listed edönme

    SizedBox(
    height: 500,

    child: ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    physics: BouncingScrollPhysics(),
    itemCount: 5,


    itemBuilder: (BuildContext context, int i) {

    return Card(

    child: ExpansionTile(
    title: Text(
    "sipariş",
    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
    ),
    children: List<Widget>.generate(
    5,
    (index) => ListTile(  dense: true,
    visualDensity: VisualDensity(vertical: -3),

    //foreach don alt alta subtitle yazdır
    subtitle: Row(   children: [  Text("data", style: TextStyle(fontWeight: FontWeight.w500), ),Text("data"),Text("2rf")  ,    ],   ),

    )),
    ),);

    },),),

    ),**/




