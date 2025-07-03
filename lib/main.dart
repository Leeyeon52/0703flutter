// C:\Users\sptzk\Desktop\t0703\lib\main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart'; // AuthViewModel 임포트
import 'features/mypage/viewmodel/userinfo_viewmodel.dart'; // UserInfoViewModel 임포트

void main() {
  runApp(
    // ✅ MultiProvider를 사용하여 여러 뷰모델을 동시에 제공
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => UserInfoViewModel()), // ✅ UserInfoViewModel 추가
      ],
      child: const MediToothApp(),
    ),
  );
}

class MediToothApp extends StatelessWidget {
  const MediToothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MediTooth',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}