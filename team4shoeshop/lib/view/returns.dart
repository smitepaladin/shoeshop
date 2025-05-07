import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/model/orders.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class Returns extends StatefulWidget {
  const Returns({super.key});

  @override
  State<Returns> createState() => _ReturnsState();
}

class _ReturnsState extends State<Returns> {
  final handler = DatabaseHandler();
  final box = GetStorage();

  Future<List<Map<String, dynamic>>> _loadMyReturns() async {
    final cid = box.read('p_userId') ?? '';
    final db = await handler.initializeDB();

    final orders = await db.query(
      'orders',
      where: 'ocid = ? AND oreturncount != 0',
      whereArgs: [cid],
    );

    List<Map<String, dynamic>> result = [];
    for (final order in orders) {
      final product = await handler.getProductByPid(order['opid'].toString());
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
      appBar: AppBar(title: Text('반품 내역')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadMyReturns(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('반품 내역이 없습니다.'));
          }

          final returns = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: returns.length,
            itemBuilder: (context, index) {
              final order = returns[index]['order'] as Orders;
              final product = returns[index]['product'] as Product;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('반품 상태: ${order.oreturnstatus}', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('상품명: ${product.pname}'),
                      Text('브랜드: ${product.pbrand}'),
                      Text('색상: ${product.pcolor}'),
                      Text('사이즈: ${product.psize}'),
                      Text('반품 수량: ${order.oreturncount}개'),
                      Text('반품일자: ${order.oreturndate.split("T").first}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
