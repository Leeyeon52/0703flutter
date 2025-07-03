import 'package:flutter/material.dart';

class ChatbotViewModel extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void sendMessage(String message) {
    _messages.add(ChatMessage(role: 'user', content: message));
    notifyListeners();

    // TODO: 실제 챗봇 API 호출로 대체
    Future.delayed(const Duration(milliseconds: 500), () {
      _messages.add(ChatMessage(role: 'bot', content: '모의 응답입니다.'));
      notifyListeners();
    });
  }
}

class ChatMessage {
  final String role; // 'user' or 'bot'
  final String content;

  ChatMessage({required this.role, required this.content});
}