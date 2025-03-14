import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProxy {
  static Future<Map<String, dynamic>> post(String url, Map<String, dynamic> data) async {
    try {
      // Try direct request first
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': 'http://localhost',
        },
        body: jsonEncode(data),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      
      // If direct request fails, try using a CORS proxy
      final proxyUrl = 'https://corsproxy.io/?${Uri.encodeComponent(url)}';
      final proxyResponse = await http.post(
        Uri.parse(proxyUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': 'http://localhost',
        },
        body: jsonEncode(data),
      );
      
      if (proxyResponse.statusCode == 200) {
        return jsonDecode(proxyResponse.body);
      }
      
      throw Exception('Failed to make API request: ${proxyResponse.statusCode}');
    } catch (e) {
      throw Exception('API proxy error: $e');
    }
  }
}
