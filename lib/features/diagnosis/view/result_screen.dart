import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('진단 결과'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home'); // ✅ 홈화면으로 이동
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('🦷 진단 결과'),
            SizedBox(height: 20),
            Text('치아 번호: 11'),
            Text('진단 결과: 충치 의심'),
          ],
        ),
      ),
    );
  }
}