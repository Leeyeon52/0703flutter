// C:\Users\sptzk\Desktop\t0703\lib\features\mypage\view\edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/model/user.dart'; // User 모델 임포트
import '../viewmodel/userinfo_viewmodel.dart'; // UserInfoViewModel 임포트
import '../../auth/viewmodel/auth_viewmodel.dart'; // AuthViewModel 임포트 (업데이트 API 호출용)
import 'package:flutter/foundation.dart'; // kDebugMode 사용을 위해 임포트

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // 폼 유효성 검사를 위한 키
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late DateTime _selectedBirthDate;
  late String _selectedGender;

  // 사용자 정보 로드 상태를 추적하는 변수
  bool _isUserDataLoaded = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback를 사용하여 initState 완료 후 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData();
    });
  }

  void _initializeUserData() {
    final user = context.read<UserInfoViewModel>().user;

    if (kDebugMode) {
      print('EditProfileScreen _initializeUserData: user = $user');
    }

    if (user == null) {
      if (kDebugMode) {
        print('EditProfileScreen: User is null, redirecting to login.');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사용자 정보를 불러올 수 없습니다. 다시 로그인해주세요.')),
      );
      context.go('/login'); // 로그인 화면으로 강제 이동
    } else {
      // 사용자 정보가 있을 때만 컨트롤러 초기화
      _nameController = TextEditingController(text: user.name);
      _phoneController = TextEditingController(text: user.phone);
      _addressController = TextEditingController(text: user.address);

      // birth 필드 파싱 시 오류 방어 코드 추가
      try {
        _selectedBirthDate = DateTime.parse(user.birth);
        if (kDebugMode) {
          print('생년월일 파싱 성공: ${user.birth} -> $_selectedBirthDate');
        }
      } catch (e) {
        if (kDebugMode) {
          print('생년월일 파싱 오류: ${user.birth}, 오류: $e');
        }
        _selectedBirthDate = DateTime.now(); // 파싱 실패 시 현재 날짜로 기본값 설정
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('생년월일 정보가 올바르지 않습니다. 기본값으로 설정됩니다.')),
        );
      }
      _selectedGender = user.gender;

      setState(() {
        _isUserDataLoaded = true; // 데이터 로드 완료
      });
      if (kDebugMode) {
        print('EditProfileScreen: User data initialized successfully.');
      }
    }
  }

  @override
  void dispose() {
    // 컨트롤러가 초기화되었을 때만 dispose 호출
    if (_isUserDataLoaded) {
      _nameController.dispose();
      _phoneController.dispose();
      _addressController.dispose();
    }
    super.dispose();
  }

  // 생년월일 선택 다이얼로그
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  // 개인정보 저장 로직
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final userInfoViewModel = context.read<UserInfoViewModel>();
      final authViewModel = context.read<AuthViewModel>(); // AuthViewModel을 통해 업데이트 API 호출

      final userId = userInfoViewModel.user?.userId;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용자 ID를 찾을 수 없습니다. 다시 로그인해주세요.')),
        );
        context.go('/login');
        return;
      }

      final updatedUserData = {
        'user_id': userId, // 사용자 ID는 변경되지 않음
        'name': _nameController.text,
        'gender': _selectedGender,
        'birth': '${_selectedBirthDate.year}-${_selectedBirthDate.month.toString().padLeft(2, '0')}-${_selectedBirthDate.day.toString().padLeft(2, '0')}', // 'YYYY-MM-DD' 형식으로 변환
        'phone': _phoneController.text,
        'address': _addressController.text,
      };

      if (kDebugMode) {
        print('개인정보 업데이트 요청 데이터: $updatedUserData');
      }

      // TODO: AuthViewModel에 updateUserProfile 함수 구현 필요
      // 실제 구현 시:
      // final error = await authViewModel.updateUserProfile(updatedUserData);
      // if (error == null) {
      //   userInfoViewModel.setUser(User.fromJson(updatedUserData)); // 로컬 사용자 정보 업데이트
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('개인정보가 성공적으로 수정되었습니다.')),
      //   );
      //   context.pop(); // 이전 화면으로 돌아가기
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('개인정보 수정 실패: $error')),
      //   );
      // }

      // 임시 성공 처리 (실제 API 연동 전까지)
      userInfoViewModel.setUser(User.fromJson(updatedUserData)); // 로컬 사용자 정보 업데이트
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('개인정보가 성공적으로 수정되었습니다. (API 연동 필요)')),
      );
      context.pop(); // 이전 화면으로 돌아가기
    }
  }

  @override
  Widget build(BuildContext context) {
    // _isUserDataLoaded가 false일 때는 로딩 스피너를 보여줍니다.
    if (!_isUserDataLoaded) {
      return const Scaffold(
        appBar: AppBar(title: Text('개인정보 수정')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 사용자 정보가 null이거나 초기화되지 않았다면, 빈 화면 대신 로딩 스피너를 표시
    final user = context.watch<UserInfoViewModel>().user;
    if (user == null) {
       // 이 경우는 _isUserDataLoaded가 false일 때 이미 처리되지만, 만약을 위해 추가
       return const Scaffold(
        appBar: AppBar(title: Text('개인정보 수정')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 수정'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이디 (수정 불가)
              TextFormField(
                initialValue: user.userId,
                readOnly: true, // 아이디는 수정 불가
                decoration: const InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 20),

              // 이름
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 성별
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: '성별',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('남성')),
                  DropdownMenuItem(value: 'F', child: Text('여성')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '성별을 선택해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 생년월일
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: '${_selectedBirthDate.year}-${_selectedBirthDate.month.toString().padLeft(2, '0')}-${_selectedBirthDate.day.toString().padLeft(2, '0')}',
                    ),
                    decoration: const InputDecoration(
                      labelText: '생년월일 (YYYY-MM-DD)',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '생년월일을 선택해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 전화번호
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: '전화번호',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '전화번호를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 주소
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: '주소',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2, // 주소는 여러 줄 입력 가능
              ),
              const SizedBox(height: 30),

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('저장', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
