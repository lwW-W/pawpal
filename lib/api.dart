import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  // Base server URL used for all API calls
  static const String server = "http://10.117.129.179/pawpal";

  // Register User Function
  // Sends POST request to register_user.php
  // Parameters: name, email, password, phone
  // Returns: Decoded JSON response from the server
  static Future<Map<String, dynamic>> registerUser(
      String name, String email, String password, String phone) async {

    // Send HTTP POST request with user registration data
    final res = await http.post(
      Uri.parse("$server/api/register_user.php"),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone
      },
    );

    return jsonDecode(res.body);
  }

  // Login User Function
  // Sends POST request to login_user.php
  // Parameters: email, password
  // Returns: Decoded JSON response from the server
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {

    // Send HTTP POST request with login data
    final res = await http.post(
      Uri.parse("$server/api/login_user.php"),
      body: {
        'email': email,
        'password': password
      },
    );

    return jsonDecode(res.body);
  }
}
