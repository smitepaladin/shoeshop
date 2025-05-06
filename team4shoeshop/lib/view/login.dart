import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/adminlogin.dart';
import 'package:team4shoeshop/view/joincustomer.dart';
import 'package:team4shoeshop/view/shoeslistpage.dart';

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

  initStorage(){ 
    box.write('p_userId', ""); // 초기값을 비어있는걸로 지정
    box.write('p_password', "");
  }

  @override
  void dispose() {
    disposeStorage(); // 앱 종료할 때 지우기
    super.dispose();
  }

  disposeStorage(){
    box.erase();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('images/login.png'),
                radius: 70,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: userIdController,
                  decoration: InputDecoration(
                    labelText: '사용자 ID를 입력하세요'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: '패스워드를 입력하세요'
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if(userIdController.text.trim().isEmpty || passwordController.text.trim().isEmpty){
                    errorSnackBar();
                  }else{
                    _showDialog();
                  }
                }, 
                child: Text('Log In'),
              ),
              ElevatedButton(
                onPressed: () => Get.to(Joincustomer()), 
                child: Text('회원가입'),
              ),
              ElevatedButton(
                onPressed: () => Get.off(Adminlogin()), 
                child: Text('관리자 페이지'),
              ),
            ],
          ),
        ),
      ),
    );
  } // build

  // --- Functions ---
  errorSnackBar(){
    Get.snackbar(
      '경고', 
      '사용자 ID와 암호를 입력하세요',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      colorText: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error
    );
  }

  _showDialog(){
    Get.defaultDialog(
      title: '환영합니다',
      middleText: '신분이 확인되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // 다이얼로그 지우기
            saveStorage(); // Id, Password 저장
            Get.to(Shoeslistpage()); // 화면 이동
          }, 
          child: Text('Exit'),
        ),
      ]
    );
  }

  saveStorage(){
    box.write('p_userId', userIdController.text);
  }
  
} // class