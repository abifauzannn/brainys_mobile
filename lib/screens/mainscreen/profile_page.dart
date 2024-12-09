import 'package:flutter/material.dart';
import 'package:utspbb_2021130020/widgets/subscriptionPage/form_section.dart';
import 'package:utspbb_2021130020/services/auth_service.dart'; // Import AuthService
import 'package:utspbb_2021130020/screens/authentication/login_page.dart'; // Assuming LoginPage is in this location
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences

class DetailProfilePage extends StatefulWidget {
  @override
  _DetailProfilePageState createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  bool isLoading = true; // To show loading indicator
  String userName = '';
  String userSchool = '';

  // Fetch user profile data on page load
  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // Method to fetch user profile
  Future<void> _fetchUserProfile() async {
    try {
      final data = await AuthService().fetchUserProfile();

      // Update the state with the fetched data
      setState(() {
        userName = data['data']['name'] ?? 'Unknown';
        userSchool = data['data']['school_name'] ?? 'Unknown';
        isLoading = false;
      });
    } catch (e) {
      // Handle error if profile fetching fails
      setState(() {
        isLoading = false;
      });
      print('Error fetching user profile: $e');
    }
  }

  // Logout method to clear the token and redirect to the login page
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
          child: Column(
            children: [
              // Expanded pertama
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF0C3B98),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Baris pertama (Hello text dan Icon)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Kolom untuk teks
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Check if data is still loading, display a loading indicator
                                isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        'Hello, $userName',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                // Dynamically displaying the user school
                                isLoading
                                    ? SizedBox
                                        .shrink() // Hide school name while loading
                                    : Text(
                                        userSchool,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                              ],
                            ),
                            // Container untuk ikon profil
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(15.0), // Circle shape
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person, // Icon profile
                                color: Color(
                                    0xFF0C3B98), // Blue color for the icon
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              Expanded(
                flex: 6,
                child: DetailInformation(), // Assuming this widget also displays other information
              ),

              // Logout button at the bottom of the screen
              
            ],
          ),
        ),
      ),
    );
  }
}
