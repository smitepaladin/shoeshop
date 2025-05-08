import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/model/orders.dart';
import 'package:team4shoeshop/model/employee.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/edit_profile_page.dart';
import 'package:team4shoeshop/view/buy.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final DatabaseHandler handler = DatabaseHandler();
  final box = GetStorage();
  List<Map<String, dynamic>> cartItems = [];
  Set<String> selectedItems = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final cid = box.read('p_userId');
    if (cid == null) {
      Get.snackbar('알림', '로그인이 필요합니다.',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      Get.back();
      return;
    }

    final db = await handler.initializeDB();
    final List<Map<String, dynamic>> orders = await db.query(
      'orders',
      where: 'ocartbool = ? and ocid = ?',
      whereArgs: [1, cid],
    );

    List<Map<String, dynamic>> items = [];
    for (var order in orders) {
      final product = await handler.getProductByPid(order['opid']);
      final store = await db.query(
        'employee',
        where: 'eid = ?',
        whereArgs: [order['oeid']],
      );

      if (product != null) {
        items.add({
          'product': product,
          'order': Orders.fromMap(order),
          'store': store.isNotEmpty ? Employee.fromMap(store.first) : null,
        });
      }
    }
      cartItems = items;
      isLoading = false;
    setState(() { });
  }

  Future<void> _removeFromCart(String oid) async {
    final db = await handler.initializeDB();
    await db.update(
      'orders',
      {'ocartbool': 0},
      where: 'oid = ?',
      whereArgs: [oid],
    );
    await _loadCartItems();
  }

  void _toggleItemSelection(String oid) {
    setState(() {
      if (selectedItems.contains(oid)) {
        selectedItems.remove(oid);
      } else {
        selectedItems.add(oid);
      }
    });
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final product = item['product'] as Product;
    final order = item['order'] as Orders;
    final store = item['store'] as Employee?;
    final isSelected = selectedItems.contains(order.oid.toString());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: isSelected,
          onChanged: (_) => _toggleItemSelection(order.oid.toString()),
        ),
        title: Text(product.pname),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${product.pprice}원'),
            Text('수량: ${order.ocount}'),
            Text('사이즈: ${product.psize}'),
            Text('색상: ${product.pcolor}'),
            Text('구매 대리점: ${store?.ename ?? '미지정'}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _removeFromCart(order.oid.toString()),
        ),
      ),
    );
  }

  int _getTotalPrice() {
    return cartItems.fold(0, (sum, item) {
      final product = item['product'] as Product;
      final order = item['order'] as Orders;
      if (selectedItems.contains(order.oid.toString())) {
        return sum + (product.pprice * order.ocount);
      }
      return sum;
    });
  }

  Future<void> _checkCardInfoAndProceed() async {
    final cid = box.read('p_userId');
    if (cid == null) {
      Get.snackbar('알림', '로그인이 필요합니다.',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      return;
    }

    final db = await handler.initializeDB();
    final result = await db.query(
      'customer',
      where: 'cid = ?',
      whereArgs: [cid],
    );

    if (result.isEmpty) {
      Get.snackbar('오류', '사용자 정보를 찾을 수 없습니다.',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      return;
    }

    final customer = result.first;
    if (customer['ccardnum'] == 0 || customer['ccardcvc'] == 0 || customer['ccarddate'] == 0) {
      Get.snackbar('카드 정보 없음', '회원정보를 먼저 수정해주세요.',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      await Future.delayed(Duration(seconds: 1));
      Get.to(() => const EditProfilePage());
      return;
    }

    final selectedProducts = cartItems.where((item) {
      final order = item['order'] as Orders;
      return selectedItems.contains(order.oid.toString());
    }).map((item) {
      final product = item['product'] as Product;
      final order = item['order'] as Orders;
      final store = item['store'] as Employee?;
      return {
        'product': product,
        'quantity': order.ocount,
        'storeId': store?.eid,
      };
    }).toList();

    if (selectedProducts.isEmpty) {
      Get.snackbar('알림', '선택된 상품이 없습니다.',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      return;
    }

    // 재고 부족 확인
    for (var item in selectedProducts) {
      final product = item['product'] as Product;
      final quantity = item['quantity'] as int;
      if (quantity > product.pstock) {
        Get.snackbar('재고 부족', '${product.pname}의 재고가 부족합니다.',
          duration: Duration(seconds: 2),
          backgroundColor: Colors.blue);
        return;
      }
    }

    // ✅ 문제 없으면 구매 페이지 이동
    Get.to(() => const BuyPage(), arguments: {
      'products': selectedProducts,
      'isFromCart': true,
    });
  }

  Future<void> _proceedToCheckout() async {
    if (selectedItems.isEmpty) {
      Get.snackbar('알림', '결제할 상품을 선택해주세요.',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      return;
    }

    await _checkCardInfoAndProceed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('장바구니'),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  if (selectedItems.length == cartItems.length) {
                    selectedItems.clear();
                  } else {
                    selectedItems = Set.from(
                      cartItems.map((item) => (item['order'] as Orders).oid.toString()),
                    );
                  }
                });
              },
              child: Text(
                selectedItems.length == cartItems.length ? '전체 해제' : '전체 선택',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text('장바구니가 비어있습니다.'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: cartItems.map(_buildCartItem).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '선택된 상품: ${selectedItems.length}개',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                '총합: ${_getTotalPrice()}원',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _proceedToCheckout,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('선택 상품 주문하기'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
