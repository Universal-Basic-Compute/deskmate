import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

class ChatService {
  final String apiUrl = 'https://duogaming.ai/api/send-message';
  final FlutterTts flutterTts = FlutterTts();

  ChatService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<String> sendMessage(String message, String username) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
          'username': username,
          'character': 'DeskMate',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data['response'] as String;
        
        // Speak the response
        await speakResponse(botResponse);
        
        return botResponse;
      } else {
        final error = jsonDecode(response.body);
        return 'Error: ${error['error'] ?? 'Unknown error'}';
      }
    } catch (e) {
      return 'Connection error: $e';
    }
  }

  Future<void> speakResponse(String text) async {
    await flutterTts.speak(text);
  }

  void dispose() {
    flutterTts.stop();
  }
}
