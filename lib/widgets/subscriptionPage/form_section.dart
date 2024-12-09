import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utspbb_2021130020/services/auth_service.dart';
import 'package:utspbb_2021130020/screens/authentication/login_page.dart';

class DetailInformation extends StatefulWidget {
  const DetailInformation({Key? key}) : super(key: key);

  @override
  _DetailInformationState createState() => _DetailInformationState();
}

class _DetailInformationState extends State<DetailInformation> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _professionController = TextEditingController();
  bool _isEditing = false;
  bool _isLoading = false;
  String? _selectedLevel;
  String _errorMessage = ''; // For displaying errors

  // Instance of AuthService
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // Fetch the user profile
  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ''; // Reset error message
    });

    try {
      final userProfile = await _authService.fetchUserProfile();

      // Populate controllers with user profile data
      _usernameController.text = userProfile['data']['name'];
      _schoolController.text = userProfile['data']['school_name'];
      _professionController.text = userProfile['data']['profession'];

      // Set the dropdown value according to the fetched school level
      setState(() {
        _selectedLevel =
            userProfile['data']['school_level']; // Set the school_level
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = error.toString(); // Capture the error message
      });
    }
  }

  Future<void> _logout() async {
    // Clear the token from SharedPreferences (or wherever it's stored)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Remove the stored token

    // After removing the token, redirect to the LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }

  Widget buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Jenjang',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedLevel,
          items: [
            {'label': 'SD/MI Sederajat', 'value': 'sd'},
            {'label': 'SMP/MTs Sederajat', 'value': 'smp'},
            {'label': 'SMA/SMK/MA Sederajat', 'value': 'sma'},
            {'label': 'Pendidikan Kesetaraan Paket A', 'value': 'paketa'},
            {'label': 'Pendidikan Kesetaraan Paket B', 'value': 'paketb'},
            {'label': 'Pendidikan Kesetaraan Paket C', 'value': 'paketc'},
          ].map((level) {
            return DropdownMenuItem<String>(
              value: level['value'],
              child: Text(level['label']!),
            );
          }).toList(),
          onChanged: _isEditing
              ? (value) {
                  setState(() {
                    _selectedLevel = value;
                  });
                }
              : null,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Jenjang tidak boleh kosong';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: _isEditing ? const Color(0xFFF6F7FA) : Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? const Color(0xFFF6F7FA) : Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildActionButtons() {
    return _isEditing
        ? Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: handleSave,
                  child: const Text('Simpan Perubahan'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: handleCancel,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Batalkan'),
                ),
              ),
            ],
          )
        : ElevatedButton(
            onPressed: handleEdit,
            child: const Text('Edit Profil'),
          );
  }

  void handleEdit() {
    setState(() {
      _isEditing = true;
    });
  }

  void handleCancel() {
    setState(() {
      _isEditing = false;
    });
  }

  void handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perubahan berhasil disimpan!')),
        );
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _schoolController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: ScrollConfiguration(
      behavior: ScrollBehavior().copyWith(scrollbars: false), // Removes the scroll indicator
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage.isNotEmpty)
                Center(
                    child: Text(_errorMessage,
                        style: TextStyle(color: Colors.red))),
              buildTextField(
                label: 'Nama Lengkap',
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Lengkap tidak boleh kosong';
                  }
                  return null;
                },
                enabled: _isEditing,
              ),
              buildTextField(
                label: 'Asal Sekolah',
                controller: _schoolController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Asal Sekolah tidak boleh kosong';
                  }
                  return null;
                },
                enabled: _isEditing,
              ),
              buildTextField(
                label: 'Profesi',
                controller: _professionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Profesi tidak boleh kosong';
                  }
                  return null;
                },
                enabled: _isEditing,
              ),
              buildDropdown(),
              buildActionButtons(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Button color
                    padding: EdgeInsets.symmetric(vertical: 15.0), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Custom ScrollBehavior to remove the glow effect (scroll indicator)


}
