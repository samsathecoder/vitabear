import 'package:flutter/material.dart';
import 'rounded_button.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login_screen');
                  },child: Text("Giriş Yap"),
                ),
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, '/registration_screen');
                }, child: Text("Üye Ol"))

              ]),
        ));
  }
}
