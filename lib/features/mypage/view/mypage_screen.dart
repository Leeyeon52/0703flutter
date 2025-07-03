import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/viewmodel/auth_viewmodel.dart'; // AuthViewModel 임포트
import '../viewmodel/userinfo_viewmodel.dart'; // UserInfoViewModel 임포트


class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  // 스낵바 표시 유틸리티 함수
  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
          title: const Text('회원 탈퇴'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('정말로 회원 탈퇴하시겠습니까?'),
              const Text('모든 데이터가 삭제되며 복구할 수 없습니다.'),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호를 다시 입력해주세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // 취소
              },
              child: const Text('취소'),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('탈퇴', style: TextStyle(color: Colors.white)),
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
      appBar: AppBar(title: const Text('마이페이지')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보 섹션
            Text('👤 이름: ${user?.name ?? '로그인 필요'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('📧 아이디: ${user?.userId ?? '로그인 필요'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            const Divider(),

            // 계정 설정 섹션
            const Text('🛠️ 계정 설정', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // 개인정보 수정 버튼 추가
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: 개인정보 수정 화면으로 이동하는 라우트 추가 필요
                  context.go('/mypage/edit'); // 예시 라우트
                },
                icon: const Icon(Icons.edit),
                label: const Text('개인정보 수정', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 로그아웃 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  userInfoViewModel.clearUser(); // 사용자 정보 지우기
                  _showSnack(context, '로그아웃 되었습니다.');
                  context.go('/login'); // 로그인 화면으로 이동
                },
                icon: const Icon(Icons.logout),
                label: const Text('로그아웃', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 회원탈퇴 버튼
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showDeleteConfirmationDialog(context), // 회원 탈퇴 다이얼로그 호출
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text('회원탈퇴', style: TextStyle(fontSize: 16, color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: Colors.red), // 테두리 색상
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
