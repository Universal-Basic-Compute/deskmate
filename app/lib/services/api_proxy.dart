import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProxy {
  static Future<Map<String, dynamic>> post(String url, Map<String, dynamic> data) async {
    try {
      // Replace mydeskmate.ai with duogaming.ai in the URL if present
      String adjustedUrl = url.replaceAll('mydeskmate.ai', 'duogaming.ai');
      
      // Make direct API request without proxy
      final response = await http.post(
        Uri.parse(adjustedUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      
      throw Exception('Failed to make API request: ${response.statusCode}');
    } catch (e) {
      throw Exception('API request error: $e');
    }
  }
}
