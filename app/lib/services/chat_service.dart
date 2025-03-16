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
    } catch (e) {
      print('Error using TTS API: $e');
      _isPlaying = false;
    }
  }

  Future<String> sendImageMessage(String imagePath, String username) async {
    try {
      print('Sending image to API: $imagePath');
      
      if (kIsWeb) {
        // Web implementation - use fetch API with proper blob handling
        
        // Create a completer to handle the async response
        final completer = Completer<String>();
        
        // For web, we need to convert the blob URL to actual binary data
        final xhr = html.HttpRequest();
        xhr.responseType = 'blob';
        xhr.open('GET', imagePath);
        
        xhr.onLoad.listen((_) async {
          if (xhr.status == 200) {
            final blob = xhr.response as html.Blob;
            
            // Create a FormData object
            final formData = html.FormData();
            
            // Add the blob to the form data with the correct field name 'screenshot'
            formData.appendBlob('screenshot', blob, 'image.jpg');
            
            // Add other fields
            formData.append('username', username);
            formData.append('character', 'DeskMate');
            
            // Send the actual request with the image data
            final uploadXhr = html.HttpRequest();
            uploadXhr.open('POST', 'https://mydeskmate.ai/api/screenshot');
            
            uploadXhr.onLoad.listen((_) {
              if (uploadXhr.status == 200) {
                final data = jsonDecode(uploadXhr.responseText ?? '{"response": "No response received"}');
                final botResponse = data['response'] as String? ?? 'No response received';
                
                // Speak the response
                try {
                  speakResponse(botResponse);
                } catch (e) {
                  print('TTS error: $e');
                }
                
                completer.complete(botResponse);
              } else {
                print('API error: ${uploadXhr.status} - ${uploadXhr.responseText}');
                completer.complete('Sorry, I encountered an error processing your image. Please try again later.');
              }
            });
            
            uploadXhr.onError.listen((_) {
              print('Upload XHR error');
              completer.complete('Sorry, I\'m having trouble processing your image. Please check your internet connection.');
            });
            
            // Send the request with the form data
            uploadXhr.send(formData);
          } else {
            print('Blob fetch error: ${xhr.status}');
            completer.complete('Sorry, I couldn\'t process the image. Please try again.');
          }
        });
        
        xhr.onError.listen((_) {
          print('Blob XHR error');
          completer.complete('Sorry, I\'m having trouble accessing your image. Please try again.');
        });
        
        // Send the request to get the blob
        xhr.send();
        
        // Return the future from the completer
        return completer.future;
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

  void dispose() {
    audioPlayer.dispose();
  }
}
