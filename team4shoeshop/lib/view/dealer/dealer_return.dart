import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/dealer/dealer_widget/dealer_widget.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:team4shoeshop/view/dealer/dealer_return_detail.dart';

class DealerReturn extends StatefulWidget {
  const DealerReturn({super.key});

  @override
  State<DealerReturn> createState() => _DealerReturnState();
}

class _DealerReturnState extends State<DealerReturn> {
  final handler = DatabaseHandler();
  final box = GetStorage();
  List<Map<String, dynamic>> returnOrders = [];

  @override
  void initState() {
    super.initState();
    fetchReturnOrders();
  }

  Future<void> fetchReturnOrders() async {
    final db = await handler.initializeDB();
    final String eid = box.read('adminId') ?? '';

    final result = await db.rawQuery('''
      SELECT o.*, p.pname
      FROM orders o
      JOIN product p ON o.opid = p.pid
      WHERE o.oeid = ?
        AND o.odate IS NOT NULL AND o.odate != ''
      ORDER BY o.odate DESC
    ''', [eid]);

    setState(() {
      returnOrders = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('반품 내역 관리'),
        centerTitle: true,
      ),
      drawer: DealerDrawer(),
      body: returnOrders.isEmpty
          ? const Center(child: Text('주문 내역이 없습니다.'))
          : ListView.builder(
              itemCount: returnOrders.length,
              itemBuilder: (context, index) {
                final item = returnOrders[index];
                final hasReturn = (item['oreturndate'] != null && item['oreturndate'].toString().isNotEmpty);

                return Card(
                  margin: const EdgeInsets.all(8),
                  color: hasReturn ? Colors.red[50] : null,
                  child: ListTile(
                    leading: const Icon(Icons.assignment_return),
                    title: Text(item['pname'] ?? '상품명 없음'),
                    subtitle: Text(
                      '주문일: ${item['odate']} / 반품일: ${item['oreturndate'] ?? '없음'}',
                      style: TextStyle(
                        color: hasReturn ? Colors.red : Colors.black87,
                        fontWeight: hasReturn ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      final result = await Get.to(() => DealerReturnDetail(orderMap: item));
                      if (result == true) {
                        fetchReturnOrders();
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
