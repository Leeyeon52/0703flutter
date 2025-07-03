import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart'; // AuthViewModel 임포트
import '../viewmodel/userinfo_viewmodel.dart'; // UserInfoViewModel 임포트

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  // 스낵바 표시 유틸리티 함수
  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2), // 스낵바 표시 시간
        behavior: SnackBarBehavior.floating, // 플로팅 스타일
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // 둥근 모서리
        margin: const EdgeInsets.all(15), // 마진
      ),
    );
  }

  // 회원 탈퇴 확인 다이얼로그 표시
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final userInfoViewModel = context.read<UserInfoViewModel>();
    final authViewModel = context.read<AuthViewModel>();

    // 현재 로그인된 사용자 정보가 없으면 탈퇴 진행 불가
    if (userInfoViewModel.user == null) {
      _showSnack(context, '로그인 정보가 없습니다.');
      return;
    }

    // 비밀번호 재확인을 위한 컨트롤러
    final passwordController = TextEditingController();

    // 다이얼로그 표시
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // 둥근 모서리
          title: const Text(
            '회원 탈퇴',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '정말로 회원 탈퇴하시겠습니까?',
                style: TextStyle(fontSize: 15),
              ),
              const Text(
                '모든 데이터가 삭제되며 복구할 수 없습니다.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호를 다시 입력해주세요',
                  hintText: '비밀번호 입력',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // 취소
              },
              child: const Text('취소', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final userId = userInfoViewModel.user!.userId;
                final password = passwordController.text;

                if (password.isEmpty) {
                  _showSnack(dialogContext, '비밀번호를 입력해주세요.');
                  return;
                }

                // 회원 탈퇴 요청
                final error = await authViewModel.deleteUser(userId, password);

                if (error == null) {
                  Navigator.of(dialogContext).pop(true); // 탈퇴 성공
                } else {
                  _showSnack(dialogContext, error); // 오류 메시지 표시
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('탈퇴', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    // 다이얼로그 결과 처리
    if (confirm == true) {
      userInfoViewModel.clearUser(); // 사용자 정보 삭제
      _showSnack(context, '회원 탈퇴가 완료되었습니다.');
      context.go('/login'); // 로그인 화면으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    // UserInfoViewModel을 watch하여 사용자 정보 변경에 반응
    final userInfoViewModel = context.watch<UserInfoViewModel>();
    final user = userInfoViewModel.user; // 현재 로그인된 사용자 정보

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '마이페이지',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5, // 앱바 그림자
      ),
      body: SingleChildScrollView( // 스크롤 가능하도록 SingleChildScrollView 추가
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보 섹션
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.only(bottom: 30),
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                    const Divider(height: 20, thickness: 1),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.grey, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          '이름: ${user?.name ?? '로그인 필요'}',
                          style: const TextStyle(fontSize: 17, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.grey, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          '아이디: ${user?.userId ?? '로그인 필요'}',
                          style: const TextStyle(fontSize: 17, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 계정 설정 섹션
            const Text(
              '계정 설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // 개인정보 수정 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go('/mypage/edit'); // 예시 라우트
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  '개인정보 수정',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3, // 버튼 그림자
                ),
              ),
            ),
            const SizedBox(height: 15),

            // 로그아웃 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  userInfoViewModel.clearUser(); // 사용자 정보 지우기
                  _showSnack(context, '로그아웃 되었습니다.');
                  context.go('/login'); // 로그인 화면으로 이동
                },
                icon: const Icon(Icons.logout, color: Colors.black87),
                label: const Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 17, color: Colors.black87),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // 회원탈퇴 버튼
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showDeleteConfirmationDialog(context), // 회원 탈퇴 다이얼로그 호출
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  '회원탈퇴',
                  style: TextStyle(fontSize: 17, color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.red, width: 1.5), // 테두리 색상 및 두께
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
