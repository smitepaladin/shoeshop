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
    super.dispose();
  }


  Future<Employee?> validateAdmin(String id, String password) async {
    final db = await handler.initializeDB();
    final result = await db.query(
      'employee',
      where: 'eid = ? and epassword = ?',
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
    backgroundColor: Colors.grey[100],
    appBar: AppBar(
      title: const Text(
        '관리자 로그인',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.blue[700],
    ),
    body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('images/login.png'),
                  radius: 60,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: adminIdController,
                  decoration: InputDecoration(
                    labelText: '관리자 ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: adminpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '패스워드',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (adminIdController.text.trim().isEmpty ||
                          adminpasswordController.text.trim().isEmpty) {
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
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Get.off(() => const Login()),
                  child: const Text(
                    '고객 로그인으로 돌아가기',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}