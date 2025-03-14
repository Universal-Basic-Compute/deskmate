import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProxy {
  static Future<Map<String, dynamic>> post(String url, Map<String, dynamic> data) async {
    try {
      // Replace mydeskmate.ai with duogaming.ai in the URL if present
      String adjustedUrl = url.replaceAll('mydeskmate.ai', 'duogaming.ai');
      
      // Always use CORS proxy for API requests
      final proxyUrl = 'https://corsproxy.io/?${Uri.encodeComponent(adjustedUrl)}';
      final proxyResponse = await http.post(
        Uri.parse(proxyUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': 'https://deskmate.app',
        },
        body: jsonEncode(data),
      );
      
      if (proxyResponse.statusCode == 200) {
        return jsonDecode(proxyResponse.body);
      }
      
      // If CORS proxy fails, try another proxy service
      final backupProxyUrl = 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(adjustedUrl)}';
      final backupResponse = await http.post(
        Uri.parse(backupProxyUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
      
      if (backupResponse.statusCode == 200) {
        return jsonDecode(backupResponse.body);
      }
      
      throw Exception('Failed to make API request: ${proxyResponse.statusCode}');
    } catch (e) {
      throw Exception('API proxy error: $e');
    }
  }
}
