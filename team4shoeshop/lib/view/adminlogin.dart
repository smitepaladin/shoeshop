import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/admin/admin_main.dart';
import 'package:team4shoeshop/view/login.dart';

class Adminlogin extends StatefulWidget {
  const Adminlogin({super.key});

  @override
  State<Adminlogin> createState() => _AdminloginState();
}

class _AdminloginState extends State<Adminlogin> {
    // Property
  late TextEditingController adminIdController;
  late TextEditingController adminpasswordController;

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    adminIdController = TextEditingController();
    adminpasswordController = TextEditingController();
    // 초기화
    initStorage();
  }

  initStorage(){ 
    box.write('adminId', ""); // 초기값을 비어있는걸로 지정
    box.write('adminPassword', "");
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
                  controller: adminIdController,
                  decoration: InputDecoration(
                    labelText: '관리자 ID를 입력하세요'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: adminpasswordController,
                  decoration: InputDecoration(
                    labelText: '패스워드를 입력하세요'
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if(adminIdController.text.trim().isEmpty || adminpasswordController.text.trim().isEmpty){
                    errorSnackBar();
                  }else{
                    _showDialog();
                  }
                }, 
                child: Text('Log In'),
              ),
              ElevatedButton(
                onPressed: () => Get.off(Login()), 
                child: Text('고객 로그인'),
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
      '관리자 ID와 암호를 입력하세요',
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
            Get.off(AdminMain()); // 화면 이동
          }, 
          child: Text('Exit'),
        ),
      ]
    );
  }

  saveStorage(){
    box.write('adminId', adminIdController.text);
  }
  
} // class