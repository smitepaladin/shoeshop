import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/model/orders.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class OrderViewPage extends StatefulWidget {
  const OrderViewPage({super.key});

  @override
  State<OrderViewPage> createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {
  late DatabaseHandler handler;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  Future<List<Map<String, dynamic>>> fetchOrderWithProduct() async {
    final cid = box.read('p_userId');
    if (cid == null) {
      Get.snackbar('알림', '로그인이 필요합니다.');
      Get.back();
      return [];
    }

    final db = await handler.initializeDB();
    final List<Map<String, dynamic>> orders = await db.query(
      'orders',
      where: 'ocid = ? AND ocartbool = ?',
      whereArgs: [cid, 0], // 장바구니가 아닌 주문만 조회
    );

    List<Map<String, dynamic>> result = [];
    for (final order in orders) {
      final product = await handler.getProductByPid(order['opid']);
      if (product != null) {
        result.add({
          'order': Orders.fromMap(order),
          'product': product,
        });
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 주문 내역'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOrderWithProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('주문 내역이 없습니다.'));
          }
          final orderList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              final order = orderList[index]['order'] as Orders;
              final product = orderList[index]['product'] as Product;
              final isCompleted = order.ostatus == '고객수령완료';
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.yellow[200] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.odate, style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.pink[100],
                          ),
                          child: product.pimage.isNotEmpty
                              ? Image.memory(product.pimage, fit: BoxFit.cover)
                              : Center(child: Text('신발\n이미지', textAlign: TextAlign.center)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('상품명 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(product.pname),
                                  SizedBox(width: 10),
                                  Text('SIZE ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${product.psize}'),
                                  SizedBox(width: 10),
                                  Text('수량 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${order.ocount}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('브랜드 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(product.pbrand),
                                  SizedBox(width: 10),
                                  Text('색깔 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(product.pcolor),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('가격 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${product.pprice}원'),
                                ],
                              ),
                              if (isCompleted)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    order.ostatus,
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => Get.back(),
          child: Text('홈'),
        ),
      ),
    );
  }
}
