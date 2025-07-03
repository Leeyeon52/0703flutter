import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 앱 로고 (옵션)
                const Icon(Icons.medical_services_outlined, size: 64, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  '메디투스 진단 시스템',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 48),

                // 📷 사진으로 진단
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/upload');
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('사진으로 진단'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  ),
                ),

                const SizedBox(height: 20),

                // 📂 이전 결과 보기
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.push('/history');
                    },
                    icon: const Icon(Icons.folder_open),
                    label: const Text('이전 결과 보기'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}