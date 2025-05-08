import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final box = GetStorage();
  final handler = DatabaseHandler();

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

    nameController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    detailAddressController = TextEditingController();
    cardNumController = TextEditingController();
    cardCvcController = TextEditingController();
    cardDateController = TextEditingController();

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
      cardNumController.text = customer.ccardnum != 0
          ? formatCardNumber(customer.ccardnum.toString())
          : '';
      cardCvcController.text =
          customer.ccardcvc != 0 ? customer.ccardcvc.toString() : '';
      cardDateController.text =
          customer.ccarddate != 0 ? customer.ccarddate.toString() : '';
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

    final cardDateText = cardDateController.text.trim();
    int cardDate = 0;

    if (cardDateText.length == 4) {
      final mm = int.tryParse(cardDateText.substring(2));
      if (mm == null || mm < 1 || mm > 12) {
        Get.snackbar('입력 오류', '유효기간의 MM은 01~12 사이여야 합니다.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      cardDate = int.tryParse(cardDateText) ?? 0;
    } else {
      Get.snackbar('입력 오류', '유효기간은 YYMM 형식의 4자리 숫자여야 합니다.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    await db.update(
      'customer',
      {
        'cname': nameController.text.trim(),
        'cpassword': passwordController.text.trim(),
        'cphone': phoneController.text.trim(),
        'cemail': emailController.text.trim(),
        'caddress': addressController.text.trim(),
        'ccardnum': int.tryParse(cardNumController.text.replaceAll('-', '')) ?? 0,
        'ccardcvc': int.tryParse(cardCvcController.text.trim()) ?? 0,
        'ccarddate': cardDate,
      },
      where: 'cid = ?',
      whereArgs: [userId],
    );

    Get.snackbar(
      '수정 완료',
      '회원정보가 저장되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    await _loadProfile();
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAll(() => const Shoeslistpage());
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
                  _buildField(nameController, '이름'),
                  _buildField(passwordController, '비밀번호', obscure: true),
                  _buildField(
                    phoneController,
                    '전화번호',
                    keyboard: TextInputType.number,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                      PhoneNumberFormatter(),
                    ],
                  ),
                  _buildField(emailController, '이메일'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          basicAddress.isNotEmpty
                              ? basicAddress
                              : '주소를 선택해주세요',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: _searchAddress,
                        child: const Text('주소 검색'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildField(detailAddressController, '상세 주소',
                      onChanged: (_) => _combineAddress()),
                  _buildField(addressController, '최종 주소 (자동완성)', readOnly: true),
                  const SizedBox(height: 16),
                  _buildField(
                    cardNumController,
                    '카드번호',
                    keyboard: TextInputType.number,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      CardNumberFormatter(),
                    ],
                  ),
                  _buildField(
                    cardCvcController,
                    'CVC',
                    keyboard: TextInputType.number,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                  _buildField(
                    cardDateController,
                    '유효기간 (YYMM)',
                    keyboard: TextInputType.number,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('수정 완료'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    bool readOnly = false,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatters,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        readOnly: readOnly,
        keyboardType: keyboard,
        inputFormatters: formatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  String formatCardNumber(String number) {
    number = number.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < number.length; i++) {
      buffer.write(number[i]);
      if ((i + 1) % 4 == 0 && i + 1 != number.length) buffer.write('-');
    }
    return buffer.toString();
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i + 1) % 4 == 0 && i + 1 != digits.length) buffer.write('-');
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted.length > 19 ? formatted.substring(0, 19) : formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
