// C:\Users\sptzk\Desktop\t0703\lib\features\auth\viewmodel\auth_viewmodel.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart'; // User 모델 임포트

class AuthViewModel with ChangeNotifier {
  final String _baseUrl = "http://10.0.2.2:5000"; // 에뮬레이터용 주소 또는 PC IP 주소

  /// 사용자 ID 중복 검사
  Future<bool?> checkUserIdDuplicate(String userId) async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/auth/exists?user_id=$userId'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['exists'] == true;
      } else {
        if (kDebugMode) {
          print('ID 중복검사 서버 응답 오류: StatusCode=${res.statusCode}, Body=${res.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('ID 중복검사 중 네트워크 오류: $e');
      }
      return null;
    }
  }

  /// 사용자 회원가입
  Future<String?> registerUser(Map<String, String> userData) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (res.statusCode == 201) {
        return null;
      } else {
        final data = jsonDecode(res.body);
        return data['error'] ?? '알 수 없는 오류가 발생했습니다.';
      }
    } catch (e) {
      if (kDebugMode) {
        print('회원가입 중 네트워크 오류: $e');
      }
      return '서버와 연결할 수 없습니다. 네트워크 상태를 확인해주세요.';
    }
  }

  /// 사용자 로그인
  /// 반환값: User 객체 (로그인 성공), String (오류 메시지)
  Future<User?> loginUser(String userId, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'password': password}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        // 서버에서 반환된 'user' 객체를 User 모델로 파싱
        return User.fromJson(data['user']); // ✅ User 객체 반환
      } else {
        final data = jsonDecode(res.body);
        // 오류 메시지를 문자열로 반환
        throw data['error'] ?? '아이디 또는 비밀번호가 잘못되었습니다.';
      }
    } catch (e) {
      if (kDebugMode) {
        print('로그인 중 네트워크 오류: $e');
      }
      // 네트워크 오류 시 사용자에게 표시할 메시지 반환
      throw '서버와 연결할 수 없습니다. 네트워크 상태를 확인해주세요.';
    }
  }

  // ✅ 회원 탈퇴 함수 추가
  /// 사용자 회원 탈퇴
  /// [userId] 탈퇴할 사용자 ID
  /// [password] 사용자 비밀번호 (재확인용)
  /// 반환값: null (성공), String (오류 메시지)
  Future<String?> deleteUser(String userId, String password) async {
    try {
      final res = await http.delete(
        Uri.parse('$_baseUrl/auth/delete_account'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'password': password}),
      );

      if (res.statusCode == 200) {
        return null; // 회원 탈퇴 성공
      } else {
        final data = jsonDecode(res.body);
        // 서버에서 반환된 오류 메시지 사용
        return data['error'] ?? '회원 탈퇴 중 알 수 없는 오류가 발생했습니다.';
      }
    } catch (e) {
      if (kDebugMode) {
        print('회원 탈퇴 중 네트워크 오류: $e');
      }
      return '서버와 연결할 수 없습니다. 네트워크 상태를 확인해주세요.';
    }
  }
}