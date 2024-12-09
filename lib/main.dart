import 'package:flutter/material.dart';
import 'package:utspbb_2021130020/screens/authentication/register_page.dart';
import 'package:utspbb_2021130020/screens/authentication/splash.dart';
import 'package:utspbb_2021130020/screens/authentication/login_page.dart';
import 'package:utspbb_2021130020/screens/authentication/reedemInvitation_page.dart';
import 'package:utspbb_2021130020/screens/mainscreen/mainscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Set SplashScreen sebagai halaman default
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/mainScreen': (context) => MainScreen(),
        '/splash': (context) => Splash(),
      },
    );
  }
}