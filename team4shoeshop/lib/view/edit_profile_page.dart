import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/model/customer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:team4shoeshop/view/shoeslistpage.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final box = GetStorage(); // 로그인 시 저장된 ID 읽기용
  final handler = DatabaseHandler();

  // 사용자 정보 입력 필드
  late TextEditingController nameController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController detailAddressController;
  late TextEditingController cardNumController;
  late TextEditingController cardCvcController;
  late TextEditingController cardDateController;

  String basicAddress = '';
  String userId = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // 텍스트 필드 초기화
    nameController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController(); // 최종 주소
    detailAddressController = TextEditingController(); // 상세주소
    cardNumController = TextEditingController();
    cardCvcController = TextEditingController();
    cardDateController = TextEditingController();

    // 저장된 사용자 ID 불러오기
    userId = box.read('p_userId') ?? '';
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (userId.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final db = await handler.initializeDB();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM customer WHERE cid = ?',
      [userId],
    );

    if (result.isNotEmpty) {
      final customer = Customer.fromMap(result.first);
      nameController.text = customer.cname;
      passwordController.text = customer.cpassword;
      phoneController.text = customer.cphone;
      emailController.text = customer.cemail;
      addressController.text = customer.caddress;
      cardNumController.text = customer.ccardnum != 0 ? customer.ccardnum.toString() : '';
      cardCvcController.text = customer.ccardcvc != 0 ? customer.ccardcvc.toString() : '';
      cardDateController.text = customer.ccarddate != 0 ? customer.ccarddate.toString() : '';
    }

    setState(() {
      isLoading = false;
    });
  }

  void _combineAddress() {
    final detail = detailAddressController.text.trim();
    final full = '$basicAddress ${detail.isNotEmpty ? detail : ''}'.trim();
    addressController.text = full;
  }

  Future<void> _searchAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RemediKopo()),
    );

    if (result is KopoModel && result.address != null) {
      setState(() {
        basicAddress = result.address!;
        _combineAddress();
      });
    }
  }

  Future<void> _updateProfile() async {
    final db = await handler.initializeDB();

    await db.update(
      'customer',
      {
        'cname': nameController.text.trim(),
        'cpassword': passwordController.text.trim(),
        'cphone': phoneController.text.trim(),
        'cemail': emailController.text.trim(),
        'caddress': addressController.text.trim(),
        'ccardnum': int.tryParse(cardNumController.text.trim()) ?? 0,
        'ccardcvc': int.tryParse(cardCvcController.text.trim()) ?? 0,
        'ccarddate': int.tryParse(cardDateController.text.trim()) ?? 0,
      },
      where: 'cid = ?',
      whereArgs: [userId],
    );

    Get.snackbar(
      '수정 완료',
      '회원정보가 저장되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );

    await _loadProfile();
    Future.delayed(Duration(seconds: 1), () {
      Get.offAll(() => Shoeslistpage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원정보 수정')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: '이름')),
                  TextField(controller: passwordController, decoration: const InputDecoration(labelText: '비밀번호')),
                  TextField(controller: phoneController, decoration: const InputDecoration(labelText: '전화번호')),
                  TextField(controller: emailController, decoration: const InputDecoration(labelText: '이메일')),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(basicAddress.isNotEmpty ? basicAddress : '주소를 선택해주세요'),
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
                    controller: addressController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: '최종 주소 (자동완성)'),
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: cardNumController, decoration: const InputDecoration(labelText: '카드번호')),
                  TextField(controller: cardCvcController, decoration: const InputDecoration(labelText: 'CVC')),
                  TextField(controller: cardDateController, decoration: const InputDecoration(labelText: '유효기간 (YYMM)')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('수정 완료'),
                  ),
                ],
              ),
            ),
    );
  }
}


