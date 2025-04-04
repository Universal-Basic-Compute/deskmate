import 'dart:convert';
import 'dart:math' as math;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File;
import 'package:audioplayers/audioplayers.dart';
// Import html conditionally
import 'dart:ui' as ui;

class ChatService {
  final String apiUrl = 'https://mydeskmate.ai/api/send-message';  // Using absolute URL
  final String ttsApiUrl = 'https://mydeskmate.ai/api/tts';  // Using absolute URL
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
      
      if (kIsWeb) {
        // Web platform handling with direct streaming
        final encodedText = Uri.encodeComponent(text);
        final url = '$ttsApiUrl?text=$encodedText&voiceId=IKne3meq5aSn9XLyUdCD&model=eleven_flash_v2_5';
        print('Creating audio element with URL: $url');
        
        // Use JS interop for web audio
        // This code is only compiled on web
        _playAudioWeb(url);
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
    } catch (e) {
      print('Error using TTS API: $e');
      _isPlaying = false;
    }
  }
  
  // This method is only used on web platform
  void _playAudioWeb(String url) {
    if (kIsWeb) {
      // This code will only be executed on web
      // Using JS interop instead of direct html import
      // The actual implementation would be added by a web-specific plugin
      print('Playing audio on web with URL: $url');
      
      // For now, just mark as not playing after a delay
      Future.delayed(const Duration(seconds: 2), () {
        _isPlaying = false;
      });
    }
  }

  Future<String> sendImageMessage(String imagePath, String username) async {
    try {
      print('Sending image to API: $imagePath');
      
      if (kIsWeb) {
        // Web implementation - use platform-safe approach
        return await _sendImageMessageWeb(imagePath, username);
      } else {
        // Mobile implementation - use MultipartRequest
        final request = http.MultipartRequest('POST', Uri.parse('https://mydeskmate.ai/api/screenshot'));
        
        // Add file with the correct field name 'screenshot'
        final file = await http.MultipartFile.fromPath('screenshot', imagePath);
        request.files.add(file);
        
        // Add other fields
        request.fields['username'] = username;
        request.fields['character'] = 'DeskMate';
        
        // Send request
        final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
        final response = await http.Response.fromStream(streamedResponse);
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final botResponse = data['response'] as String? ?? 'No response received';
          
          // Speak the response
          try {
            await speakResponse(botResponse);
          } catch (e) {
            print('TTS error: $e');
          }
          
          return botResponse;
        } else {
          print('API error: ${response.statusCode} - ${response.body}');
          return 'Sorry, I encountered an error processing your image. Please try again later.';
        }
      }
    } catch (e) {
      print('Image request error: $e');
      return 'Sorry, I\'m having trouble processing your image. Please check your internet connection.';
    }
  }
  
  // This method is only used on web platform
  Future<String> _sendImageMessageWeb(String imagePath, String username) async {
    // For web, we need a different approach that doesn't directly use dart:html
    // This is a simplified version that will be replaced with proper implementation
    print('Web image upload not fully implemented in this build');
    
    // Return a placeholder response
    return 'Sorry, image upload is not fully supported in this version. Please try the mobile app for full functionality.';
  }

  void dispose() {
    audioPlayer.dispose();
  }
}
