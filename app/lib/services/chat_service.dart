import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

class ChatService {
  final String apiUrl = 'https://duogaming.ai/api/send-message';
  final String ttsApiUrl = 'https://duogaming.ai/api/utils/tts';
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  ChatService() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
    });
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
    try {
      // Cancel any ongoing speech
      if (_isPlaying) {
        await audioPlayer.stop();
      }
      
      _isPlaying = true;
      
      // Call the TTS API endpoint
      final response = await http.post(
        Uri.parse(ttsApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': text,
          'voiceId': 'IKne3meq5aSn9XLyUdCD', // Default ElevenLabs voice ID
          'model': 'eleven_flash_v2_5'
        }),
      );
      
      if (response.statusCode == 200) {
        // Get temporary directory to save the audio file
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/tts_response.mp3';
        
        // Write the audio data to a file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        // Play the audio file
        await audioPlayer.play(DeviceFileSource(filePath));
      } else {
        print('TTS API failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error using TTS API: $e');
      _isPlaying = false;
    }
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
