import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/adminlogin.dart';
import 'package:team4shoeshop/view/joincustomer.dart';
import 'package:team4shoeshop/view/shoeslistpage.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Property
  late TextEditingController userIdController;
  late TextEditingController passwordController;

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    userIdController = TextEditingController();
    passwordController = TextEditingController();
    // 초기화
    initStorage();
  }

  initStorage() {
    box.write('p_userId', ""); // 초기값을 비어있는걸로 지정
    box.write('p_password', "");
  }

  @override
  void dispose() {
    super.dispose();
  }

  disposeStorage() {
    box.erase();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Log In')),
    body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'images/bcdmart.png',
                width: 160,
                height: 160,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 32),

              TextField(
                controller: userIdController,
                decoration: InputDecoration(
                  labelText: '사용자 ID를 입력하세요',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '패스워드를 입력하세요',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (userIdController.text.trim().isEmpty ||
                        passwordController.text.trim().isEmpty) {
                      errorSnackBar();
                    } else {
                      final handler = DatabaseHandler();
                      bool loginSuccess = await handler.checkLogin(
                        userIdController.text.trim(),
                        passwordController.text.trim(),
                      );

                      if (loginSuccess) {
                        saveStorage();
                        _showDialog();
                      } else {
                        Get.snackbar(
                          '로그인 실패',
                          'ID 또는 비밀번호가 잘못되었습니다.',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.login),
                  label: Text('로그인', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Get.to(Joincustomer()),
                    icon: Icon(Icons.person_add),
                    label: Text('회원가입'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Get.off(Adminlogin()),
                    icon: Icon(Icons.admin_panel_settings),
                    label: Text('관리자 페이지'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  // --- Functions ---
  errorSnackBar() {
    Get.snackbar(
      '경고',
      '사용자 ID와 암호를 입력하세요',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      colorText: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: '환영합니다',
      middleText: '신분이 확인되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            saveStorage(); // 먼저 저장
            Get.back(); // 다이얼로그 닫기
            Get.to(() => Shoeslistpage()); // 그 다음 화면 이동
          },
          child: Text('Exit'),
        ),
      ],
    );
  }

  saveStorage() {
    box.write('p_userId', userIdController.text);
  }
} // class
