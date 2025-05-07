import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/model/orders.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:get_storage/get_storage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final DatabaseHandler handler = DatabaseHandler(); // db핸들러
  final box = GetStorage(); // 로그인한 id정보 들고다니기 위해 스토리지 사용용
  List<Map<String, dynamic>> cartItems = []; // {product: Product, order: Orders}
  Set<String> selectedItems = {}; // 선택된 상품의 oid를 저장
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final cid = box.read('p_userId');
    if (cid == null) {
      Get.snackbar('알림', '로그인이 필요합니다.');
      Get.back();
      return;
    }

    final db = await handler.initializeDB();
    // 장바구니에 있는 주문 목록 가져오기
    final List<Map<String, dynamic>> orders = await db.query(
      'orders',
      where: 'ocartbool = ? AND ocid = ?',
      whereArgs: [1, cid],
    );

    List<Map<String, dynamic>> items = [];
    for (var order in orders) {
      // 각 주문에 해당하는 상품 정보 가져오기
      final product = await handler.getProductByPid(order['opid']);
      if (product != null) {
        items.add({
          'product': product,
          'order': Orders.fromMap(order),
        });
      }
    }

    setState(() {
      cartItems = items;
      isLoading = false;
    });
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

  Future<void> _proceedToCheckout() async {
    if (selectedItems.isEmpty) {
      Get.snackbar('알림', '결제할 상품을 선택해주세요.');
      return;
    }
    final db = await handler.initializeDB();
    final cid = box.read('p_userId'); // 카드 결제 연동시 필요요

    // 선택된 상품들 처리
    for (var item in cartItems) {
      final order = item['order'] as Orders;
      if (selectedItems.contains(order.oid.toString())) {
        // 장바구니에서 제거
        await db.update(
          'orders',
          {'ocartbool': 0},
          where: 'oid = ?',
          whereArgs: [order.oid],
        );

        // 주문 상태 업데이트
        await db.update(
          'orders',
          {
            'ostatus': '결제완료',
            'odate': DateTime.now().toIso8601String(),
          },
          where: 'oid = ?',
          whereArgs: [order.oid],
        );

        // 재고 차감
        final product = item['product'] as Product;
        await db.update(
          'product',
          {'pstock': product.pstock - order.ocount},
          where: 'pid = ?',
          whereArgs: [product.pid],
        );
      }
    }

    Get.snackbar('결제 완료', '선택한 상품이 결제되었습니다.', duration: Duration(seconds: 1));
    await _loadCartItems(); // 장바구니 새로고침
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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