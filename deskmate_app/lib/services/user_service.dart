import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class UserService {
  final String apiUrl = 'https://mydeskmate.ai/api/register-user';

  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      print('Registering user: $firstName $lastName ($email)');
      
      final response = await http.post(
        Uri.parse(apiUrl),
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
}
