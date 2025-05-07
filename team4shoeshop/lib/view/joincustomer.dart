import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/model/customer.dart';
import 'package:team4shoeshop/view/login.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

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
  final TextEditingController caddressController = TextEditingController(); // 최종 주소
  final TextEditingController detailAddressController = TextEditingController(); // 상세주소

  String basicAddress = ''; // 기본주소

  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  Future<void> _searchAddress() async {
    KopoModel? model = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RemediKopo()),
    );

    if (model != null && model.address != null) {
      setState(() {
        basicAddress = model.address!;
        _combineAddress(); // 기본주소 바뀔 때 결합도 반영
      });
    }
  }

  void _combineAddress() {
    final detail = detailAddressController.text.trim();
    final fullAddress = '$basicAddress ${detail.isNotEmpty ? detail : ''}'.trim();
    caddressController.text = fullAddress;
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
      Get.offAll(() => const Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cidController,
              decoration: const InputDecoration(labelText: '아이디'),
            ),
            TextField(
              controller: cnameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: cpasswordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            TextField(
              controller: cphoneController,
              decoration: const InputDecoration(labelText: '전화번호'),
            ),
            TextField(
              controller: cemailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(basicAddress.isNotEmpty ? basicAddress : '주소를 선택하세요.'),
                ),
                TextButton(
                  onPressed: _searchAddress,
                  child: const Text('주소 검색'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: detailAddressController,
              onChanged: (_) => _combineAddress(),
              decoration: const InputDecoration(labelText: '상세 주소'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: caddressController,
              readOnly: true,
              decoration: const InputDecoration(labelText: '최종 주소 (자동완성)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _join,
              child: const Text('가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}

