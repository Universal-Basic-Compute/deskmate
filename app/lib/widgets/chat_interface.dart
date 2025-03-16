import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class ChatInterface extends StatefulWidget {
  const ChatInterface({super.key});

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isCapturingImage = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatService.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final chatModel = Provider.of<ChatModel>(context, listen: false);
    final userModel = Provider.of<UserModel>(context, listen: false);
    
    // Clear input field
    _messageController.clear();
    
    // Add user message to chat
    chatModel.addMessage(message, true);
    _scrollToBottom();
    
    // Set loading state
    chatModel.setLoading(true);
    
    // Send message to API
    final response = await _chatService.sendMessage(
      message, 
      userModel.name ?? 'Student'
    );
    
    // Add bot response to chat
    chatModel.addMessage(response, false);
    
    // Clear loading state
    chatModel.setLoading(false);
    _scrollToBottom();
  }

  // Handle image capture
  Future<void> _captureImage() async {
    setState(() {
      _isCapturingImage = true;
    });

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 85,
      );

      setState(() {
        _isCapturingImage = false;
      });

      if (image != null) {
        // Show confirmation dialog
        final bool shouldSend = await _showImageConfirmationDialog(image);
        
        if (shouldSend && mounted) {
          final chatModel = Provider.of<ChatModel>(context, listen: false);
          final userModel = Provider.of<UserModel>(context, listen: false);
          
          // Add image message to chat
          chatModel.addImageMessage(image.path, true);
          _scrollToBottom();
          
          // Set loading state
          chatModel.setLoading(true);
          
          // Send image to API
          final response = await _chatService.sendImageMessage(
            image.path,
            userModel.name ?? 'Student'
          );
          
          // Add bot response to chat
          chatModel.addMessage(response, false);
          
          // Clear loading state
          chatModel.setLoading(false);
          _scrollToBottom();
        }
      }
    } catch (e) {
      print('Error capturing image: $e');
      setState(() {
        _isCapturingImage = false;
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to capture image. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Show confirmation dialog
  Future<bool> _showImageConfirmationDialog(XFile image) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: darkGrey,
        title: const Text('Send this image?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Check if running on web
            kIsWeb
                ? Image.network(
                    image.path,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.white70,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  )
                : Image.file(
                    File(image.path),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryYellow,
              foregroundColor: darkGrey,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Send'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatModel>(
      builder: (context, chatModel, child) {
        return Column(
          children: [
            // Chat messages
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: darkGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatModel.messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
            ),
            
            // Loading indicator
            if (chatModel.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryYellow),
                    strokeWidth: 2,
                    backgroundColor: darkGrey,
                  ),
                ),
              ),
            
            // Message input
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: darkGrey.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ask DeskMate...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: darkGrey,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: violetAccent.withOpacity(0.3), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: primaryYellow, width: 2),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Camera button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: violetGradient,
                      boxShadow: [
                        BoxShadow(
                          color: violetAccent.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _isCapturingImage ? null : _captureImage,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _isCapturingImage
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Send button
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: yellowOrangeGradient,
                      boxShadow: [
                        BoxShadow(
                          color: primaryYellow.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _sendMessage,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.send,
                            color: darkGrey,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: message.isUser 
            ? LinearGradient(
                colors: [primaryYellow, orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [violetAccent, Color(0xFF6A2FDF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (message.isUser ? primaryYellow : violetAccent).withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: message.imagePath != null
            ? _buildImageContent(message.imagePath!)
            : Text(
                message.content,
                style: TextStyle(
                  color: message.isUser ? darkGrey : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  Widget _buildImageContent(String imagePath) {
    // Check if running on web
    if (kIsWeb) {
      // For web, use a network image or a placeholder
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imagePath,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 200,
              height: 200,
              color: Colors.grey[800],
              child: const Center(
                child: Icon(
                  Icons.image,
                  color: Colors.white70,
                  size: 40,
                ),
              ),
            );
          },
        ),
      );
    } else {
      // For mobile, use file image
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(imagePath),
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
