import 'package:flutter/foundation.dart';

class Message {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatModel extends ChangeNotifier {
  final List<Message> _messages = [];
  bool _isLoading = false;

  List<Message> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;

  void addMessage(String content, bool isUser) {
    _messages.add(Message(
      content: content,
      isUser: isUser,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
