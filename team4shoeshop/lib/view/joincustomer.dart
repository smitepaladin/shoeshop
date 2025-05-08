import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController cidController = TextEditingController();
  final TextEditingController cnameController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  final TextEditingController cphoneController = TextEditingController();
  final TextEditingController cemailController = TextEditingController();
  final TextEditingController caddressController = TextEditingController();
  final TextEditingController detailAddressController = TextEditingController();

  String basicAddress = '';
  bool isCidChecked = false;

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
        _combineAddress();
      });
    }
  }

  void _combineAddress() {
    final detail = detailAddressController.text.trim();
    final fullAddress = '$basicAddress ${detail.isNotEmpty ? detail : ''}'.trim();
    caddressController.text = fullAddress;
  }

  Future<void> checkCidDuplicate() async {
    final cid = cidController.text.trim();
    if (cid.isEmpty) {
      Get.snackbar('오류', 'ID를 입력하세요', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final exists = await handler.isCidDuplicate(cid);
    if (exists) {
      Get.snackbar('중복된 ID', '이미 사용 중인 ID입니다.', backgroundColor: Colors.orange, colorText: Colors.white);
      setState(() {
        isCidChecked = false;
      });
    } else {
      Get.snackbar('사용 가능', '사용 가능한 ID입니다.', backgroundColor: Colors.green, colorText: Colors.white);
      setState(() {
        isCidChecked = true;
      });
    }
  }

  Future<void> _join() async {
    if (!isCidChecked) {
      Get.snackbar('확인 필요', 'ID 중복 확인을 먼저 해주세요.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cidController,
                    decoration: InputDecoration(
                      labelText: '아이디',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (_) => setState(() => isCidChecked = false),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: checkCidDuplicate,
                  child: const Text('중복 확인'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cnameController,
              decoration: InputDecoration(
                labelText: '이름',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cpasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호',
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cphoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                PhoneNumberFormatter(),
              ],
              decoration: InputDecoration(
                labelText: '전화번호',
                prefixIcon: Icon(Icons.phone_android),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cemailController,
              decoration: InputDecoration(
                labelText: '이메일',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    basicAddress.isNotEmpty ? basicAddress : '주소를 선택하세요.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton.icon(
                  onPressed: _searchAddress,
                  icon: Icon(Icons.search),
                  label: const Text('주소 검색'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: detailAddressController,
              onChanged: (_) => _combineAddress(),
              decoration: InputDecoration(
                labelText: '상세 주소',
                prefixIcon: Icon(Icons.home_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: caddressController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: '최종 주소 (자동완성)',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _join,
                icon: Icon(Icons.check_circle_outline),
                label: const Text('가입하기', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 전화번호 자동 하이픈 포맷터 클래스
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if (i == 2 || i == 6) buffer.write('-');
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted.length > 13 ? formatted.substring(0, 13) : formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
