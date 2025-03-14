import 'dart:convert';
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
      // Create a client that will be used for the request
      final client = http.Client();
      
      try {
        final response = await client.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Origin': 'http://localhost',  // Add the origin header
          },
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
          print('API error: ${response.statusCode} - ${response.body}');
          return 'Sorry, I encountered an error. Please try again later.';
        }
      } catch (e) {
        print('Request error: $e');
        return 'Sorry, I\'m having trouble connecting to my servers. Please check your internet connection.';
      } finally {
        client.close();
      }
    } catch (e) {
      print('Connection error: $e');
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
      
      // Create a client for the request
      final client = http.Client();
      
      try {
        // Call the TTS API endpoint
        final response = await client.post(
          Uri.parse(ttsApiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Origin': 'http://localhost',  // Add the origin header
          },
          body: jsonEncode({
            'text': text,
            'voiceId': 'IKne3meq5aSn9XLyUdCD', // Default ElevenLabs voice ID
            'model': 'eleven_flash_v2_5'
          }),
        );
        
        if (response.statusCode == 200) {
        if (kIsWeb) {
          // Web platform handling
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
          // Mobile/desktop platform handling
          try {
            // Get temporary directory to save the audio file
            final directory = await getTemporaryDirectory();
            final filePath = '${directory.path}/tts_response.mp3';
            
            // Write the audio data to a file
            final file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
            
            // Play the audio file
            await audioPlayer.play(DeviceFileSource(filePath));
          } catch (e) {
            print('Error saving or playing audio file: $e');
            _isPlaying = false;
          }
        }
        } else {
          print('TTS API failed: ${response.statusCode} - ${response.body}');
          _isPlaying = false;
        }
      } catch (e) {
        print('TTS request error: $e');
        _isPlaying = false;
      } finally {
        client.close();
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
