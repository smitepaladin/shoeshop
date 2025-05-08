import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:team4shoeshop/model/orders.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/view/admin/widget/admin_drawer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class AdminSales extends StatefulWidget {
  const AdminSales({super.key});

  @override
  State<AdminSales> createState() => _AdminSalesState();
}

class _AdminSalesState extends State<AdminSales> {
  final handler = DatabaseHandler();

  Future<List<Map<String, dynamic>>> _loadReturnedOrders() async {
    final db = await handler.initializeDB();
    final orders = await db.query(
      'orders',
      where: 'oreturncount != 0',
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
      appBar: AppBar(title: const Text('지점별 전일 금일 매출')),
      drawer: AdminDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadReturnedOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('반품 내역이 없습니다.'));
          }

          final dataList = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(
                child: Text('· 반품 접수 및 처리 상태',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('반품번호 | 브랜드 | 제품명 | 컬러 | 사이즈 | 수량 | 반품일자'),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final order = dataList[index]['order'] as Orders;
                    final product = dataList[index]['product'] as Product;

                    return Card(
                      color: Colors.blue[50],
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          '${order.oreturnstatus} : '
                          '반품번호:${order.oid} | ${product.pbrand} | ${product.pname} | '
                          '${product.pcolor} | ${product.psize} | ${order.oreturncount}개 | '
                          '${order.oreturndate.split("T").first}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  } // build

  Future<int> getTodaySales() async {
  final Database db = await handler.initializeDB();
  final String today = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

  final result = await db.rawQuery('select sum(p.pprice*o.ocount) from product p, orders o where o.opid=p.pid and o.oreturncount=0 and o.odate=?',[today]);
  return Sqflite.firstIntValue(result) ?? 0;
}

Future<int> getYesterdaySales() async {
  final Database db = await handler.initializeDB();
  final DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
  final String yesterdayString = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

  final result = await db.rawQuery('select sum(p.pprice*o.ocount) from product p, orders o where o.opid=p.pid and o.odate=?',[yesterdayString]);
  return Sqflite.firstIntValue(result) ?? 0;
}

} // class