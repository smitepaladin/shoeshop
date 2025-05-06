import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/model/customer.dart';
import 'package:team4shoeshop/view/login.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class Joincustomer extends StatefulWidget {
  const Joincustomer({super.key});

  @override
  State<Joincustomer> createState() => _JoincustomerState();
}

class _JoincustomerState extends State<Joincustomer> {
  // 컨트롤러
  final TextEditingController cidController = TextEditingController();
  final TextEditingController cnameController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  final TextEditingController cphoneController = TextEditingController();
  final TextEditingController cemailController = TextEditingController();
  final TextEditingController caddressController = TextEditingController();

  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  Future<void> _join() async {
    if (cidController.text.trim().isEmpty ||
        cnameController.text.trim().isEmpty ||
        cpasswordController.text.trim().isEmpty) {
      Get.snackbar(
        '오류',
        'ID, 이름, 비밀번호는 필수 입력입니다.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final newCustomer = Customer(
      cid: cidController.text.trim(),
      cname: cnameController.text.trim(),
      cpassword: cpasswordController.text.trim(),
      cphone: cphoneController.text.trim(),
      cemail: cemailController.text.trim(),
      caddress: caddressController.text.trim(),
      ccardnum: 0,
      ccardcvc: 0,
      ccarddate: 0,
    );

    int result = await handler.insertJoin(newCustomer);
    if (result > 0) {
      Get.snackbar(
        '성공',
        '회원가입이 완료되었습니다.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAll(() => Login()); // 🔄 수정된 부분
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cidController,
              decoration: InputDecoration(labelText: '아이디'),
            ),
            TextField(
              controller: cnameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: cpasswordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            TextField(
              controller: cphoneController,
              decoration: InputDecoration(labelText: '전화번호'),
            ),
            TextField(
              controller: cemailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: caddressController,
              decoration: InputDecoration(labelText: '주소'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _join, child: Text('가입하기')),
          ],
        ),
      ),
    );
  }
}
