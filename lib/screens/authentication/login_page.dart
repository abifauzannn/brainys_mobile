import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/LoginPage/form_section.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // Call method to print the auth token
    _printAuthToken();
    _printAuthUser();
  }

  // Method to print the auth token from SharedPreferences
  Future<void> _printAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token'); // Retrieve auth_token
    if (authToken != null) {
      print('Auth Token: $authToken'); // Print the auth token to console
    } else {
      print('Auth Token not found');
    }
  }

  Future<void> _printAuthUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user'); // Retrieve auth_token
    if (user != null) {
      print('Auth Token: $user'); // Print the auth token to console
    } else {
      print('Auth Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Mengambil ukuran SafeArea (width dan height)
                double screenWidth = constraints.maxWidth;
                double screenHeight = constraints.maxHeight;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/newlogo.png',
                      width: screenWidth * 0.5, // Contoh penggunaan screenWidth
                      height: screenHeight * 0.1,
                      // fit: BoxFit.cover, // Contoh penggunaan screenHeight
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    FormSection(),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
