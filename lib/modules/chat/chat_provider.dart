import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'chat_message.dart';
import 'chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService;
  List<ChatMessage> _messages = [];

  ChatProvider(this._chatService) {
    _chatService.stream.listen((event) {
      Map<String, dynamic> data = jsonDecode(event);
      ChatMessage message = ChatMessage(
        sender: data['sender'],
        content: data['content'],
        timestamp: DateTime.parse(data['timestamp']),
      );
      _addMessage(message);
    });
  }

  List<ChatMessage> get messages => _messages;

  void _addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void sendMessage(String content) {
    _chatService.sendMessage(jsonEncode({
      'sender': 'user', // Replace with the actual user's identifier
      'content': content,
      'timestamp': DateTime.now().toIso8601String(),
    }));
  }
}
