// C:\Users\sptzk\Desktop\t0703\lib\features\mypage\view\edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart'; // AuthViewModel 임포트
import '../viewmodel/userinfo_viewmodel.dart'; // UserInfoViewModel 임포트
import '../model/user_model.dart'; // User 모델 임포트 (User 모델이 정의된 경로로 변경해주세요)

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmNewPasswordController;

  @override
  void initState() {
    super.initState();
    // UserInfoViewModel에서 현재 사용자 정보를 가져와 컨트롤러 초기화
    final userInfoViewModel = context.read<UserInfoViewModel>();
    _nameController = TextEditingController(text: userInfoViewModel.user?.name ?? '');
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  // 스낵바 표시 유틸리티 함수
  void _showSnack(String msg, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(15),
        backgroundColor: backgroundColor ?? Colors.blueGrey[700],
      ),
    );
  }

  // 개인정보 저장 처리 함수
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      _showSnack('입력 필드를 확인해주세요.');
      return;
    }

    final userInfoViewModel = context.read<UserInfoViewModel>();
    final authViewModel = context.read<AuthViewModel>();

    // 현재 로그인된 사용자 정보 확인
    final currentUser = userInfoViewModel.user;
    if (currentUser == null) {
      _showSnack('로그인 정보가 없습니다.', backgroundColor: Colors.redAccent);
      context.go('/login'); // 로그인 화면으로 이동
      return;
    }

    // 로딩 인디케이터 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
      },
    );

    String? error;

    // 1. 이름 변경 처리
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != currentUser.name) {
      try {
        await userInfoViewModel.updateUserName(currentUser.userId, newName);
        _showSnack('이름이 성공적으로 변경되었습니다.');
      } catch (e) {
        error = '이름 변경 실패: $e';
      }
    }

    // 2. 비밀번호 변경 처리
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmNewPassword = _confirmNewPasswordController.text.trim();

    if (newPassword.isNotEmpty) {
      if (currentPassword.isEmpty) {
        error = '현재 비밀번호를 입력해주세요.';
      } else if (newPassword != confirmNewPassword) {
        error = '새 비밀번호가 일치하지 않습니다.';
      } else {
        try {
          await authViewModel.updateUserPassword(currentUser.userId, currentPassword, newPassword);
          _showSnack('비밀번호가 성공적으로 변경되었습니다.');
          // 비밀번호 변경 성공 시 입력 필드 초기화
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmNewPasswordController.clear();
        } catch (e) {
          error = '비밀번호 변경 실패: $e';
        }
      }
    }

    // 로딩 인디케이터 닫기
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    if (error != null) {
      _showSnack(error, backgroundColor: Colors.redAccent);
    } else {
      _showSnack('정보가 성공적으로 저장되었습니다!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '개인정보 수정',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.grey[50], // 배경색을 아주 연한 회색으로 변경
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '내 정보',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const Divider(height: 30, thickness: 1),
                
                // 이름 입력 필드
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: '이름',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    hintText: '새 이름을 입력하세요',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    errorStyle: const TextStyle(color: Colors.redAccent),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                const Text(
                  '비밀번호 변경',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const Divider(height: 30, thickness: 1),

                // 현재 비밀번호 입력 필드
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: '현재 비밀번호',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    hintText: '현재 비밀번호를 입력해주세요',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    errorStyle: const TextStyle(color: Colors.redAccent),
                  ),
                  // 비밀번호 변경을 원치 않을 경우 필수는 아님
                  // validator: (value) {
                  //   if (_newPasswordController.text.isNotEmpty && (value == null || value.isEmpty)) {
                  //     return '새 비밀번호를 설정하려면 현재 비밀번호를 입력해야 합니다.';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 20),

                // 새 비밀번호 입력 필드
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: '새 비밀번호',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    hintText: '새 비밀번호를 입력해주세요',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.vpn_key_outlined, color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    errorStyle: const TextStyle(color: Colors.redAccent),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return '비밀번호는 6자 이상이어야 합니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 새 비밀번호 확인 입력 필드
                TextFormField(
                  controller: _confirmNewPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: '새 비밀번호 확인',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    hintText: '새 비밀번호를 다시 입력해주세요',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.check_circle_outline, color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                    errorStyle: const TextStyle(color: Colors.redAccent),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value != _newPasswordController.text) {
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // 저장 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      shadowColor: Colors.blueAccent.withOpacity(0.3),
                    ),
                    child: Text(
                      '저장',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
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
