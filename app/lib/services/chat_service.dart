import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'dart:io' show File;
import 'package:audioplayers/audioplayers.dart';
import 'api_proxy.dart';

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
      // For web platform, try multiple approaches
      if (kIsWeb) {
        // Try different CORS proxies
        final proxies = [
          'https://api.allorigins.win/raw?url=${Uri.encodeComponent(apiUrl)}',
          'https://cors-anywhere.herokuapp.com/${apiUrl}',
          'https://proxy.cors.sh/${apiUrl}',
        ];
        
        Exception? lastError;
        
        // Try each proxy until one works
        for (final proxyUrl in proxies) {
          try {
            final response = await http.post(
              Uri.parse(proxyUrl),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Origin': 'http://localhost',
                'X-Requested-With': 'XMLHttpRequest',
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
            }
          } catch (e) {
            print('Proxy error with $proxyUrl: $e');
            lastError = e as Exception;
            // Continue to the next proxy
          }
        }
        
        // If all proxies fail, try a direct request as a last resort
        try {
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
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final botResponse = data['response'] as String;
            
            // Speak the response
            await speakResponse(botResponse);
            
            return botResponse;
          }
        } catch (e) {
          print('Direct request error: $e');
          // Fall through to the fallback response
        }
        
        // If all approaches fail, return a fallback response
        return 'Sorry, I\'m having trouble connecting to my servers due to CORS restrictions. Please try using the mobile app for a better experience.';
      } else {
        // For mobile platforms, use the direct approach
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
        // For web, try multiple proxies
        final proxies = [
          'https://api.allorigins.win/raw?url=${Uri.encodeComponent(ttsApiUrl)}',
          'https://cors-anywhere.herokuapp.com/${ttsApiUrl}',
          'https://proxy.cors.sh/${ttsApiUrl}',
        ];
        
        Exception? lastError;
        
        // Try each proxy until one works
        for (final proxyUrl in proxies) {
          try {
            final response = await http.post(
              Uri.parse(proxyUrl),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Origin': 'http://localhost',
                'X-Requested-With': 'XMLHttpRequest',
              },
              body: jsonEncode({
                'text': text,
                'voiceId': 'IKne3meq5aSn9XLyUdCD',
                'model': 'eleven_flash_v2_5'
              }),
            );
            
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
              
              return; // Success, exit the method
            }
          } catch (e) {
            print('TTS proxy error with $proxyUrl: $e');
            lastError = e as Exception;
            // Continue to the next proxy
          }
        }
        
        // If all proxies fail, try direct request
        try {
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
          );
          
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
            
            return; // Success, exit the method
          }
        } catch (e) {
          print('Direct TTS request error: $e');
          // Fall through to set _isPlaying = false
        }
        
        // If we get here, all approaches failed
        _isPlaying = false;
      } else {
        // For mobile platforms, use the direct approach
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
          _isPlaying = false;
        }
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
