import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiProxy {
  static Future<Map<String, dynamic>> post(String url, Map<String, dynamic> data) async {
    try {
      // Use the original URL without replacement
      
      print('Making API request to: $url'); // Add logging
      
      // Make direct API request without proxy
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        // Return a fake response on timeout
        throw TimeoutException('API request timed out');
      });
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      
      print('API error: ${response.statusCode} - ${response.body}'); // Add logging
      return {'error': 'API request failed', 'status': response.statusCode};
    } catch (e) {
      print('API request error: $e'); // Add logging
      return {'error': 'API request exception', 'message': e.toString()};
    }
  }
}
