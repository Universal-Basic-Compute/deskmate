import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String loginUrl = 'https://mydeskmate.ai/api/login';
  final String registerUrl = 'https://mydeskmate.ai/api/register-user';

  // Login method
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Logging in user: $email');
      
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 15));

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Save token to shared preferences
        if (responseData['token'] != null) {
          await _saveToken(responseData['token']);
        }
        return responseData;
      } else {
        print('Login error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'error': responseData['error'] ?? 'Login failed with status: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Login request error: $e');
      return {
        'success': false,
        'error': 'Connection error: $e',
      };
    }
  }

  // Register method (moved from UserService)
  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      print('Registering user: $firstName $lastName ($email)');
      
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Registration error: ${response.statusCode} - ${response.body}');
        return {
          'success': false,
          'error': 'Registration failed with status: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Registration request error: $e');
      return {
        'success': false,
        'error': 'Connection error: $e',
      };
    }
  }

  // Logout method
  Future<void> logout() async {
    await _removeToken();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  // Get the auth token
  Future<String?> getToken() async {
    return _getToken();
  }

  // Save token to shared preferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get token from shared preferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Remove token from shared preferences
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
