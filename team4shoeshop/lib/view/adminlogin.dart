import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/model/employee.dart';
import 'package:team4shoeshop/view/admin/admin_main.dart';
import 'package:team4shoeshop/view/dealer/dealer_main.dart';
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
  late DatabaseHandler handler;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    adminIdController = TextEditingController();
    adminpasswordController = TextEditingController();
    handler = DatabaseHandler();
    initStorage();
  }

  void initStorage() {
    box.write('adminId', "");
    box.write('adminName', "");
    box.write('adminPermission', -1);
  }

  @override
  void dispose() {
    disposeStorage();
    super.dispose();
  }

  void disposeStorage() {
    box.erase();
  }

  Future<Employee?> validateAdmin(String id, String password) async {
    final db = await handler.initializeDB();
    final result = await db.query(
      'employee',
      where: 'eid = ? AND epassword = ?',
      whereArgs: [id, password],
    );

    if (result.isNotEmpty) {
      return Employee.fromMap(result.first);
    }
    return null;
  }

  void saveStorage(Employee employee) {
    box.write('adminId', employee.eid);
    box.write('adminName', employee.ename);
    box.write('adminPermission', employee.epermission);
  }

  void _showDialog(Employee employee) {
    Get.defaultDialog(
      title: '환영합니다',
      middleText: '신분이 확인되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            if (employee.epermission == 0) {
              Get.offAll(() => const DealerMain()); // 대리점 화면
            } else {
              Get.offAll(() => const AdminMain());  // 본사 화면
            }
          },
          child: const Text('확인'),
        ),
      ],
    );
  }

  void errorSnackBar() {
    Get.snackbar(
      '경고',
      '관리자 ID와 암호를 입력하세요',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      colorText: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log In')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                backgroundImage: AssetImage('images/login.png'),
                radius: 70,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: adminIdController,
                  decoration: const InputDecoration(
                    labelText: '관리자 ID를 입력하세요',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: adminpasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '패스워드를 입력하세요',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (adminIdController.text.trim().isEmpty || adminpasswordController.text.trim().isEmpty) {
                    errorSnackBar();
                  } else {
                    final employee = await validateAdmin(
                      adminIdController.text.trim(),
                      adminpasswordController.text.trim(),
                    );
                    if (employee != null) {
                      saveStorage(employee);
                      _showDialog(employee);
                    } else {
                      Get.snackbar(
                        '로그인 실패',
                        '아이디 또는 비밀번호가 올바르지 않습니다.',
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                        colorText: Theme.of(context).colorScheme.onError,
                        backgroundColor: Theme.of(context).colorScheme.error,
                      );
                    }
                  }
                },
                child: const Text('Log In'),
              ),
              ElevatedButton(
                onPressed: () => Get.off(() => const Login()),
                child: const Text('고객 로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
