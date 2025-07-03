import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/view/login_screen.dart';
import '../features/auth/view/register_screen.dart';
import '../features/home/view/main_scaffold.dart';         // ✅ 홈 탭 전체 포함
import '../features/chatbot/view/chatbot_screen.dart';
import '../features/mypage/view/mypage_screen.dart';
import '../features/diagnosis/view/upload_screen.dart';
import '../features/diagnosis/view/result_screen.dart';
import '../features/history/view/history_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScaffold(),  // ✅ 수정된 부분
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
        path: '/upload',
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) => const ResultScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
    ],
  );
}