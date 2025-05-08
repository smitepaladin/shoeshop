import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/admin/admin_main.dart';
import 'package:team4shoeshop/view/admin/receive.dart';
import 'package:team4shoeshop/view/login.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class Adminlogin extends StatefulWidget {
  const Adminlogin({super.key});

  @override
  State<Adminlogin> createState() => _AdminloginState();
}

class _AdminloginState extends State<Adminlogin> {
  late TextEditingController adminIdController;
  late TextEditingController adminpasswordController;
  final box = GetStorage();
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    adminIdController = TextEditingController();
    adminpasswordController = TextEditingController();
    initStorage();
  }

  void initStorage() {
    box.write('adminId', "");
    box.write('adminPassword', "");
  }

  @override
  void dispose() {
    disposeStorage();
    super.dispose();
  }

  void disposeStorage() {
    box.erase();
  }

  void saveStorage() {
    box.write('adminId', adminIdController.text);
  }

  void errorSnackBar() {
    Get.snackbar(
      '경고',
      '관리자 ID와 암호를 입력하세요',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      colorText: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  void _showDialog() async {
    final db = await handler.initializeDB();
    final result = await db.query(
      'employee',
      columns: ['epermission'],
      where: 'eid = ? AND epassword = ?',
      whereArgs: [adminIdController.text, adminpasswordController.text],
    );

    if (result.isNotEmpty) {
      final permission = int.parse(result.first['epermission'].toString());

      Get.defaultDialog(
        title: '환영합니다',
        middleText: '신분이 확인되었습니다.',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        barrierDismissible: false,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              saveStorage();

              if (permission == 1) {
                Get.off(() => AdminMain());
              } else if (permission >= 3) {
                Get.off(() => ReceivePage());
              } else {
                Get.snackbar('오류', '알 수 없는 권한입니다.');
              }
            },
            child: Text('Exit'),
          ),
        ],
      );
    } else {
      Get.snackbar('로그인 실패', 'ID 또는 비밀번호가 틀렸습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: SingleChildScrollView(
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
                  decoration: InputDecoration(labelText: '관리자 ID를 입력하세요'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: adminpasswordController,
                  obscureText: true, // 비밀번호 보안 처리
                  decoration: InputDecoration(labelText: '패스워드를 입력하세요'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (adminIdController.text.trim().isEmpty ||
                      adminpasswordController.text.trim().isEmpty) {
                    errorSnackBar();
                  } else {
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
  }
}
