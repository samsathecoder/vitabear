import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vitabearsiparishatti/mainscreen.dart';
import  'package:vitabearsiparishatti/userslogin/signup_screen.dart';
import 'package:vitabearsiparishatti/userslogin/login_screen.dart';
import 'package:vitabearsiparishatti/userslogin/welcome_screen.dart';

import 'firebase_options.dart';
import 'home_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  AuthWrapper(),
      routes: {

        '/registration_screen': (context) => const RegistrationScreen(),
        '/login_screen': (context) => LoginScreen(),
        '/home_screen': (context) => HomeScreen(),
      },
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While Firebase is initializing and the auth state is loading
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          // Handle any errors during authentication
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData) {
          // If the user is not logged in
          return WelcomeScreen()  ; // Or use Navigator to push to 'login' route
        }
        else {
          // If the user is logged in
          return  HomeScreen(); // Or use Navigator to push to 'home' route
        }
      },
    );
  }}