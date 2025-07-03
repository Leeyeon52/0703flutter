import 'package:flutter/material.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: ViewModel과 연동하여 챗봇 대화 표시
    return Scaffold(
      appBar: AppBar(title: const Text('치아 챗봇')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text('🧠 ChatGPT: 안녕하세요! 어떤 치아 고민이 있으신가요?'),
          SizedBox(height: 20),
          Text('👤 사용자: 어금니가 시려요.'),
          SizedBox(height: 20),
          Text('🧠 ChatGPT: 시린 치아는 잇몸 질환이나 충치일 수 있어요.'),
        ],
      ),
    );
  }
}