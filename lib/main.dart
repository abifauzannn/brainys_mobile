import 'package:flutter/material.dart';
import 'package:utspbb_2021130020/screens/register_page.dart';
import 'package:utspbb_2021130020/screens/splash.dart';
import 'package:utspbb_2021130020/screens/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(), // Set SplashScreen sebagai halaman default
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/forgetPassword': (context) => ForgetPassword(),
        '/mainScreen': (context) => MainScreen(),
        '/homePage': (context) => HomePage(),
        '/splash': (context) => Splash(),
      },
    );
  }
}
class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forget Password')),
      body: Center(
        child: Text('Forget Password Page'),
      ),
    );
  }
}

// Contoh halaman MainScreen
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Screen')),
      body: Center(
        child: Text('Main Screen'),
      ),
    );
  }
}

// Contoh halaman HomePage
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
