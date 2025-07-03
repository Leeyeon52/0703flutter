import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // kIsWeb 임포트

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        centerTitle: true, // 제목을 중앙에 배치
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/mypage'), // 마이페이지로 이동
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // 버튼 너비를 최대로 확장
            children: [
              // 사진으로 예측하기 버튼
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/upload');
                },
                icon: const Icon(Icons.photo_camera, size: 28, color: Colors.white), // 아이콘 색상도 변경
                label: const Text(
                  '사진으로 예측하기',
                  style: TextStyle(fontSize: 20, color: Colors.white), // ✅ 글씨 색상 변경
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor, // 버튼 배경색
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // 모서리 둥글게
                  ),
                  elevation: 5, // 그림자 효과
                ),
              ),
              const SizedBox(height: 20), // 버튼 사이 간격

              // 실시간 예측하기 버튼 (웹에서 비활성화)
              Tooltip( // 웹에서 비활성화된 이유를 툴팁으로 표시
                message: kIsWeb ? '웹에서는 이용할 수 없습니다.' : '',
                // 웹에서는 길게 눌러야 툴팁이 표시되도록 설정
                triggerMode: kIsWeb ? TooltipTriggerMode.longPress : TooltipTriggerMode.manual,
                child: ElevatedButton.icon(
                  onPressed: kIsWeb ? null : () { // 웹 환경일 경우 onPressed를 null로 설정하여 비활성화
                    context.go('/diagnosis/realtime');
                  },
                  icon: Icon(Icons.videocam, size: 28, color: kIsWeb ? Colors.black87 : Colors.white), // 아이콘 색상 변경
                  label: Text(
                    '실시간 예측하기',
                    style: TextStyle(fontSize: 20, color: kIsWeb ? Colors.black87 : Colors.white), // ✅ 글씨 색상 변경
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    // ✅ 웹에서 비활성화 시 색상을 회색으로, 아니면 기본 색상으로 설정
                    backgroundColor: kIsWeb ? Colors.grey : Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20), // 버튼 사이 간격

              // 이전결과 보기 버튼
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/history');
                },
                icon: const Icon(Icons.history, size: 28, color: Colors.white), // 아이콘 색상도 변경
                label: const Text(
                  '이전결과 보기',
                  style: TextStyle(fontSize: 20, color: Colors.white), // ✅ 글씨 색상 변경
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor, // 버튼 배경색
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
