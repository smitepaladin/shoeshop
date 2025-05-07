import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/model/customer.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:team4shoeshop/view/edit_profile_page.dart';
import 'package:team4shoeshop/view/shoeslistpage.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final handler = DatabaseHandler();

  late Product product;
  late String cid;
  final passwordController = TextEditingController();

  bool isLoading = true;
  Customer? customer;

@override
void initState() {
  super.initState();
  final box = GetStorage();
  cid = box.read('p_userId') ?? '';

  final args = Get.arguments;
  if (args is Map && args.containsKey('product')) {
    product = args['product'];
    _loadCustomer();
  } else {
    Get.snackbar("에러", "잘못된 접근입니다.");
    Get.back();
  }
}

  Future<void> _loadCustomer() async {
    final db = await handler.initializeDB();
    final result = await db.query('customer', where: 'cid = ?', whereArgs: [cid]);

    if (result.isNotEmpty) {
      customer = Customer.fromMap(result.first);

      // 카드 정보가 없으면 수정 페이지로 이동
      if (customer!.ccardnum == 0 ||
          customer!.ccardcvc == 0 ||
          customer!.ccarddate == 0) {
        Get.snackbar("카드 정보 없음", "회원정보를 먼저 수정해주세요.");
        await Future.delayed(Duration(seconds: 1));
        Get.off(() => const EditProfilePage());
        return;
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _processPurchase() async {
    final db = await handler.initializeDB();

    // orders 테이블에 삽입
    await db.insert('orders', {
      'ocid': cid,
      'opid': product.pid,
      'oeid': '', // 직원은 아직 미지정
      'ocount': 1,
      'odate': DateTime.now().toIso8601String(),
      'ostatus': '결제완료',
      'ocartbool': 0,
      'oreturncount': 0,
      'oreturndate': '',
      'oreturnstatus': '',
      'odefectivereason': '',
      'oreason': '',
    });

    // product 테이블 재고 차감
    await db.update(
      'product',
      {'pstock': product.pstock - 1},
      where: 'pid = ?',
      whereArgs: [product.pid],
    );

    Get.snackbar("구매 완료", "${product.pname} 구매가 완료되었습니다.");
    await Future.delayed(Duration(seconds: 1));
    Get.offAll(() => const Shoeslistpage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("상품 결제")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("상품명: ${product.pname}", style: TextStyle(fontSize: 18)),
                  Text("가격: ${product.pprice}원", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  const Text("카드 비밀번호 앞 두 자리", style: TextStyle(fontSize: 16)),
                  TextField(
                    controller: passwordController,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "예: 12",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _processPurchase,
                      child: const Text("구매하기"),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
