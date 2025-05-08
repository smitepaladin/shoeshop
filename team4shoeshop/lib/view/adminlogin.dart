import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/admin/admin_main.dart';
import 'package:team4shoeshop/view/login.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:team4shoeshop/model/employee.dart';

class Adminlogin extends StatefulWidget {
  const Adminlogin({super.key});

  @override
  State<Adminlogin> createState() => _AdminloginState();
}

class _AdminloginState extends State<Adminlogin> {
  // Property
  late TextEditingController adminIdController;
  late TextEditingController adminpasswordController;
  late DatabaseHandler handler;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    adminIdController = TextEditingController();
    adminpasswordController = TextEditingController();
    handler = DatabaseHandler();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> validateAdmin(String id, String password) async {
    final db = await handler.initializeDB();
    final result = await db.query(
      'employee',
      where: 'eid = ? AND epassword = ?',
      whereArgs: [id, password],
    );
    
    if (result.isNotEmpty) {
      final employee = Employee.fromMap(result.first);
      box.write('adminId', employee.eid);
      box.write('adminName', employee.ename);
      box.write('adminPermission', employee.epermission);
      // 본사 직원(h001, h002, h003) 또는 대리점 직원만 로그인 가능
      return true;
    }
    return false;
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
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '패스워드를 입력하세요'
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if(adminIdController.text.trim().isEmpty || adminpasswordController.text.trim().isEmpty){
                    errorSnackBar();
                  } else {
                    bool isValid = await validateAdmin(
                      adminIdController.text.trim(),
                      adminpasswordController.text.trim()
                    );
                    if (isValid) {
                      _showDialog();
                    } else {
                      Get.snackbar(
                        '로그인 실패',
                        '아이디 또는 비밀번호가 올바르지 않습니다.',
                        snackPosition: SnackPosition.TOP,
                        duration: Duration(seconds: 2),
                        colorText: Theme.of(context).colorScheme.onError,
                        backgroundColor: Theme.of(context).colorScheme.error
                      );
                    }
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
            Get.off(AdminMain()); // 화면 이동
          }, 
          child: Text('Exit'),
        ),
      ]
    );
  }
} // class