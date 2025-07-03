import 'package:flutter/material.dart'; // GlobalKey<NavigatorState>를 위해 필요
import 'package:go_router/go_router.dart';

import '../features/auth/view/login_screen.dart';
import '../features/auth/view/register_screen.dart';
import '../features/home/view/main_scaffold.dart';         // ✅ 홈 탭 전체 포함 (새로운 구조)
import '../features/chatbot/view/chatbot_screen.dart';
import '../features/mypage/view/mypage_screen.dart';
import '../features/diagnosis/view/upload_screen.dart';     // ✅ 사진으로 예측하기의 새로운 대상 화면
import '../features/diagnosis/view/result_screen.dart';     // ✅ 진단 결과 화면 (새로운 구조)
import '../features/history/view/history_screen.dart';
import '../features/diagnosis/view/realtime_prediction_screen.dart'; // ✅ 새로 추가된 실시간 예측 화면 임포트

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>(); // 최상위 내비게이터 키

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey, // GoRouter에 내비게이터 키 연결
    initialLocation: '/login', // 앱 시작 시 초기 경로
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // 메인 스캐폴드 (하단 탭 바 등을 포함할 수 있는 컨테이너)
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScaffold(), // ✅ HomeScreen 대신 MainScaffold로 변경
      ),
      GoRoute(
        path: '/chatbot',
        builder: (context, state) => const ChatbotScreen(),
      ),
      GoRoute(
        path: '/mypage',
        builder: (context, state) => const MyPageScreen(),
      ),
      GoRoute(
        path: '/upload', // "사진으로 예측하기" 버튼이 이동할 경로
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: '/result', // 진단 결과 화면 (이전 /diagnosis/result와 다를 수 있음)
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: '/history', // "이전결과 보기" 버튼이 이동할 경로
        builder: (context, state) => const HistoryScreen(),
      ),
      // ✅ 새로운 "실시간 예측하기" 경로 추가
      GoRoute(
        path: '/diagnosis/realtime', // 실시간 예측 화면 경로
        builder: (context, state) => const RealtimePredictionScreen(),
      ),
    ],
  );
}