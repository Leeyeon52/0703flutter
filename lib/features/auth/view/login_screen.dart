// C:\Users\sptzk\Desktop\t0703\lib\features\auth\view\login_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../viewmodel/auth_viewmodel.dart'; // AuthViewModel 임포트
import '../../mypage/viewmodel/userinfo_viewmodel.dart'; // UserInfoViewModel 임포트

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // 로그인 처리 함수
  Future<void> _login() async {
    // 폼 유효성 검사
    if (!_formKey.currentState!.validate()) {
      _showSnack('아이디와 비밀번호를 모두 입력해주세요.');
      return;
    }

    final userId = _userIdController.text.trim();
    final password = _passwordController.text.trim();

    final authViewModel = context.read<AuthViewModel>();
    final userInfoViewModel = context.read<UserInfoViewModel>(); // UserInfoViewModel 인스턴스 가져오기

    try {
      final user = await authViewModel.loginUser(userId, password); // User 객체 반환 받음
      if (user != null) {
        userInfoViewModel.loadUser(user); // ✅ 로그인 성공 시 UserInfoViewModel에 사용자 정보 로드
        _showSnack('로그인 성공!');
        context.go('/home'); // 로그인 성공 시 이동할 홈 경로 (필요에 따라 변경)
      }
    } catch (e) {
      _showSnack(e.toString()); // AuthViewModel에서 throw한 오류 메시지 표시
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '아이디를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '비밀번호를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('로그인', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('회원가입', style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}