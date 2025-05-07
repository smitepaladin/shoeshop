import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/model/customer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:team4shoeshop/view/shoeslistpage.dart';

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
  late TextEditingController cardNumController;
  late TextEditingController cardCvcController;
  late TextEditingController cardDateController;

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
    addressController = TextEditingController();
    cardNumController = TextEditingController();
    cardCvcController = TextEditingController();
    cardDateController = TextEditingController();

    // 저장된 사용자 ID 불러오기
    userId = box.read('p_userId') ?? '';
    // print('>>> [initState] Loaded userId from storage: $userId');

    _loadProfile();
  }

  // 사용자 프로필 DB에서 불러오기
  Future<void> _loadProfile() async {
    print('>>> [loadProfile] Start loading profile for userId: $userId');

    if (userId.isEmpty) {
      // print('>>> [loadProfile] userId is empty. Cannot proceed.');
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

    print('>>> [loadProfile] Query result count: ${result.length}');

    if (result.isNotEmpty) {
      final customer = Customer.fromMap(result.first);
      // print('>>> [loadProfile] Loaded customer: ${customer.cname}');

      // 필드에 값 채우기
      nameController.text = customer.cname;
      passwordController.text = customer.cpassword;
      phoneController.text = customer.cphone;
      emailController.text = customer.cemail;
      addressController.text = customer.caddress;
      cardNumController.text = customer.ccardnum != 0 ? customer.ccardnum.toString() : '';
      cardCvcController.text = customer.ccardcvc != 0 ? customer.ccardcvc.toString() : '';
      cardDateController.text = customer.ccarddate != 0 ? customer.ccarddate.toString() : '';
    } else {
      // print('>>> [loadProfile] No customer found for userId: $userId');
    }

    setState(() {
      isLoading = false;
    });
  }

  // 회원정보 수정 후 DB에 저장
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

    // print('>>> [updateProfile] Updated customer info in DB.');

    Get.snackbar('수정 완료', '회원정보가 저장되었습니다.', snackPosition: SnackPosition.BOTTOM);

    // 수정 완료 후 프로필 재로드 시도
    await _loadProfile();

    // 수정 완료 후 리스트 페이지로 이동
    Future.delayed(Duration(seconds: 1), () {
      Get.offAll(() => Shoeslistpage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원정보 수정')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  TextField(controller: nameController, decoration: InputDecoration(labelText: '이름')),
                  TextField(controller: passwordController, decoration: InputDecoration(labelText: '비밀번호')),
                  TextField(controller: phoneController, decoration: InputDecoration(labelText: '전화번호')),
                  TextField(controller: emailController, decoration: InputDecoration(labelText: '이메일')),
                  TextField(controller: addressController, decoration: InputDecoration(labelText: '주소')),
                  TextField(controller: cardNumController, decoration: InputDecoration(labelText: '카드번호')),
                  TextField(controller: cardCvcController, decoration: InputDecoration(labelText: 'CVC')),
                  TextField(controller: cardDateController, decoration: InputDecoration(labelText: '유효기간 (YYMM)')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text('수정 완료'),
                  ),
                ],
              ),
            ),
    );
  }
}

