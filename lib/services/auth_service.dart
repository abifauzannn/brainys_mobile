import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Endpoint for the login
  static const String _loginUrl = 'https://testing.brainys.oasys.id/api/login';

  // Method to handle login
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] != 'success') {
          // Handle the case where the server returns an error status
          throw data['message'] ?? 'An error occurred';
        }

        // Save token if login is successful
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = data['data']['token'];
        await prefs.setString('auth_token', token);

        return data;
      } else {
        // Handle non-200 responses and parse error message
        final errorData = json.decode(response.body);
        throw errorData['message'] ?? 'An error occurred';
      }
    } catch (error) {
      // Debugging for unexpected errors
      print('Login error: $error');
      // Rethrow the error so it can be handled in the UI
      rethrow;
    }
  }

  // Method to retrieve the stored token from SharedPreferences
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> printAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('auth_token');
    print('Stored Auth Token: $authToken'); // This will print the stored token
  }

  Future<void> printAuthUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    print('Stored User: $user'); // This will print the stored token
  }

  // Method to fetch user profile
  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      // Retrieve the stored token
      final token = await getToken();
      if (token == null) {
        throw 'No token found. Please log in again.';
      }

      // Define the URL for user profile
      const String userProfileUrl =
          'https://testing.brainys.oasys.id/api/user-profile';

      // Make the GET request with Authorization header
      final response = await http.get(
        Uri.parse(userProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] != 'success') {
          // Handle the case where the server returns an error status
          throw data['message'] ?? 'Failed to fetch user profile';
        }

        return data;
      } else {
        // Handle non-200 responses and parse error message
        final errorData = json.decode(response.body);
        throw errorData['message'] ?? 'Failed to fetch user profile';
      }
    } catch (error) {
      // Debugging for unexpected errors
      print('Fetch user profile error: $error');
      // Rethrow the error so it can be handled in the UI
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
      String username, String password, String confirmationPassword) async {
    final String registerUrl =
        'https://testing.brainys.oasys.id/api/register'; // Ganti dengan URL endpoint yang benar

    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': username,
          'password': password,
          'password_confirmation': confirmationPassword,
        }),
      );

      // Tampilkan respons lengkap di konsol
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final Map<String, dynamic> data = json.decode(response.body);

      // Cek jika status adalah success
      if (data['status'] == 'success') {
        return {
          'status': true,
          'message': data['message'],
          'user': data['data']['user'],
        };
      } else {
        // Tangani error jika status bukan success (error dalam response)
        if (data['data'] != null && data['data']['email'] != null) {
          // Periksa jika ada kesalahan spesifik pada email
          final emailErrors = data['data']['email'];
          if (emailErrors.contains('validation.unique')) {
            return {
              'status': false,
              'message': 'Email sudah digunakan.',
            };
          }
        }

        // Fallback untuk pesan error lainnya jika tidak ada kesalahan spesifik pada email
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat mendaftar.',
          'errors': data['data'] ?? {},
        };
      }
    } catch (error) {
      // Tangani exception jika terjadi error selama permintaan API
      print('Error saat registrasi: $error');
      return {
        'status': false,
        'message': 'Gagal mendaftarkan akun. Silakan coba lagi.',
      };
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    String _verifyOtpUrl = 'https://testing.brainys.oasys.id/api/verify-otp';
    try {
      final response = await http.post(
        Uri.parse(_verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Decode the response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // Save token to SharedPreferences before returning
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = data['data']['token'];
        await prefs.setString('auth_token', token);

        return {
          'status': true,
          'message': data['message'],
          'token': data['data']['token'],
          'user': data['data']['user'],
        };
      } else {
        // Handle failure scenario
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat mendaftar.',
        };
      }
    } catch (error) {
      print('Error during OTP verification: $error');
      return {
        'status': false,
        'message': 'Gagal verifikasi OTP. Silakan coba lagi.',
      };
    }
  }

  Future<Map<String, dynamic>> profileCompleted(String name, String school_name,
      String profession, String school_level) async {
    String _profileCompletedUrl =
        'https://testing.brainys.oasys.id/api/profile';

    try {
      final token = await getToken();
      if (token == null) {
        throw 'No token found. Please log in again.';
      }

      final response = await http.post(
        Uri.parse(_profileCompletedUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'name': name,
          'school_name': school_name,
          'profession': profession,
          'school_level': school_level
        }),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Decode the response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // Store user data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'user',
            json.encode(
                data['data']['user'])); // Save user data as a JSON string

        return {
          'status': true,
          'message': data['message'],
          'user': data['data']['user'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat mendaftar.',
        };
      }
    } catch (error) {
      print('Error during OTP verification: $error');
      return {
        'status': false,
        'message': 'Gagal verifikasi OTP. Silakan coba lagi.',
      };
    }
  }

  Future<Map<String, dynamic>> reedemInvitationCode(String code) async {
    String _reedemInvitationCodeUrl =
        'https://testing.brainys.oasys.id/api/user-invitations/redeem';

    try {
      final token = await getToken();
      if (token == null) {
        throw 'No token found. Please log in again.';
      }

      final response = await http.post(
        Uri.parse(_reedemInvitationCodeUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'invite_code': code}),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Decode the response body
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success' ) {
        // Update 'is_active' to 1 in the stored user data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Retrieve user data from SharedPreferences
        String? userJson = prefs.getString('user');
        if (userJson != null) {
          Map<String, dynamic> user = json.decode(userJson);

          // Set the 'is_active' field to 1
          user['is_active'] = 1;

          // Save the updated user object back to SharedPreferences
          prefs.setString('user', json.encode(user));
        }

        // No need to return anything anymore, just a success message
        return {
          'status': true,
          'message': data['message'],
        };
      } else {
        return {
          'status': false,
          'message': data['message'] ?? 'Terjadi kesalahan saat redeem kode.',
        };
      }
    } catch (error) {
      print('Error during redeeming invitation code: $error');
      return {
        'status': false,
        'message': 'Gagal redeem kode undangan. Silakan coba lagi.',
      };
    }
  }
}
