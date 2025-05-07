import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/model/customer.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:team4shoeshop/view/shoeslistpage.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final handler = DatabaseHandler();
  final box = GetStorage();
  late String cid;
  final passwordController = TextEditingController();
  bool isLoading = true;
  Customer? customer;
  List<Map<String, dynamic>> products = [];
  bool isFromCart = false;

  @override
  void initState() {
    super.initState();
    cid = box.read('p_userId') ?? '';
    final args = Get.arguments;
    if (args is Map) {
      if (args.containsKey('product')) {
        // 단일 상품 구매
        final product = args['product'] as Product;
        final quantity = args['quantity'] as int? ?? 1;
        final storeId = args['storeId'] as String?;
        products = [{
          'product': product,
          'quantity': quantity,
          'storeId': storeId,
        }];
      } else if (args.containsKey('products')) {
        // 장바구니에서 구매
        final List<dynamic> productsList = args['products'];
        products = productsList.map((item) {
          if (item is Map<String, dynamic>) {
            return {
              'product': item['product'] as Product,
              'quantity': item['quantity'] as int,
              'storeId': item['storeId'] as String?,
            };
          }
          return null;
        }).whereType<Map<String, dynamic>>().toList();
        isFromCart = args['isFromCart'] as bool? ?? false;
      }
    }
    
    if (products.isEmpty) {
      Get.snackbar("에러", "잘못된 접근입니다.");
      Get.back();
      return;
    }
    _loadCustomer();
  }

  Future<void> _loadCustomer() async {
    try {
      final db = await handler.initializeDB();
      final result = await db.query('customer', where: 'cid = ?', whereArgs: [cid]);

      if (result.isNotEmpty) {
        customer = Customer.fromMap(result.first);
      } else {
        Get.snackbar("오류", "사용자 정보를 찾을 수 없습니다.");
        Get.back();
        return;
      }
    } catch (e) {
      Get.snackbar("오류", "데이터베이스 오류가 발생했습니다.");
      Get.back();
      return;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _processPurchase() async {
    if (passwordController.text.length != 2) {
      Get.snackbar("오류", "카드 비밀번호 앞 두 자리를 입력해주세요.");
      return;
    }

    try {
      final db = await handler.initializeDB();

      for (var item in products) {
        final product = item['product'] as Product;
        final quantity = item['quantity'] as int;
        final storeId = item['storeId'] as String?;

        // 재고 확인
        if (product.pstock < quantity) {
          Get.snackbar("오류", "${product.pname}의 재고가 부족합니다.");
          return;
        }

        // 대리점 정보 확인
        if (storeId == null || storeId.isEmpty) {
          Get.snackbar("오류", "대리점 정보가 없습니다.");
          return;
        }

        if (isFromCart) {
          // 장바구니에서 온 경우: 기존 주문 업데이트
          await db.update(
            'orders',
            {
              'ostatus': '결제완료',
              'odate': DateTime.now().toIso8601String(),
              'ocartbool': 0,
            },
            where: 'ocid = ? AND opid = ? AND ocartbool = ?',
            whereArgs: [cid, product.pid, 1],
          );
        } else {
          // 단일 상품 구매의 경우: 새로운 주문 생성
          await db.insert('orders', {
            'ocid': cid,
            'opid': product.pid,
            'oeid': storeId,
            'ocount': quantity,
            'odate': DateTime.now().toIso8601String(),
            'ostatus': '결제완료',
            'ocartbool': 0,
            'oreturncount': 0,
            'oreturndate': '',
            'oreturnstatus': '',
            'odefectivereason': '',
            'oreason': '',
          });
        }

        // product 테이블 재고 차감
        await db.update(
          'product',
          {'pstock': product.pstock - quantity},
          where: 'pid = ?',
          whereArgs: [product.pid],
        );
      }

      Get.snackbar("구매 완료", "구매가 완료되었습니다.", duration: Duration(seconds: 1));
      await Future.delayed(Duration(seconds: 1));
      Get.offAll(() => const Shoeslistpage());
    } catch (e) {
      Get.snackbar("오류", "결제 처리 중 오류가 발생했습니다.");
    }
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
                  Text("결제 상품", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...products.map((item) {
                    final product = item['product'] as Product;
                    final quantity = item['quantity'] as int;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("상품명: ${product.pname}"),
                        Text("가격: ${product.pprice}원"),
                        Text("수량: $quantity"),
                        Text("총액: ${product.pprice * quantity}원"),
                        const Divider(),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),
                  const Text("카드 비밀번호 앞 두 자리", style: TextStyle(fontSize: 16)),
                  TextField(
                    controller: passwordController,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
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

