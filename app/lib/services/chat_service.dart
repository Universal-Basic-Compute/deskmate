import 'dart:convert';
import 'dart:math' as math;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'dart:io' show File;
import 'package:audioplayers/audioplayers.dart';

class ChatService {
  final String apiUrl = 'https://mydeskmate.ai/api/send-message';  // Using absolute URL
  final String ttsApiUrl = 'https://mydeskmate.ai/api/utils/tts';  // Using absolute URL
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
      print('Sending message to API: $message'); // Add logging
      
      // Make a direct API call without using the CORS proxy
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          'username': username,
          'character': 'DeskMate',
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botResponse = data['response'] as String? ?? 'No response received';
        
        // Speak the response
        try {
          await speakResponse(botResponse);
        } catch (e) {
          print('TTS error: $e'); // Just log TTS errors, don't fail the whole function
        }
        
        return botResponse;
      } else {
        print('API error: ${response.statusCode} - ${response.body}');
        return 'Sorry, I encountered an error. Please try again later.';
      }
    } catch (e) {
      print('Request error: $e');
      return 'Sorry, I\'m having trouble connecting to my servers. Please check your internet connection.';
    }
  }

  Future<void> speakResponse(String text) async {
    try {
      // Cancel any ongoing speech
      if (_isPlaying) {
        await audioPlayer.stop();
      }
      
      _isPlaying = true;
      
      // Temporarily disable TTS to avoid potential crashes
      print('TTS would speak: $text');
      _isPlaying = false;
      return;
      
      /*
      if (kIsWeb) {
        // Web platform handling with direct API call
        final response = await http.post(
          Uri.parse(ttsApiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'text': text,
            'voiceId': 'IKne3meq5aSn9XLyUdCD',
            'model': 'eleven_flash_v2_5'
          }),
        ).timeout(const Duration(seconds: 10));
        
        if (response.statusCode == 200) {
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final player = html.AudioElement()
            ..src = url
            ..autoplay = true;
          
          player.onEnded.listen((_) {
            html.Url.revokeObjectUrl(url);
            _isPlaying = false;
          });
        } else {
          print('TTS API failed: ${response.statusCode} - ${response.body}');
          _isPlaying = false;
        }
      } else {
        // Mobile platform handling with direct API call
        final response = await http.post(
          Uri.parse(ttsApiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'text': text,
            'voiceId': 'IKne3meq5aSn9XLyUdCD',
            'model': 'eleven_flash_v2_5'
          }),
        ).timeout(const Duration(seconds: 10));
        
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
          _isPlaying = false;
        }
      }
      */
    } catch (e) {
      print('Error using TTS API: $e');
      _isPlaying = false;
    }
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
