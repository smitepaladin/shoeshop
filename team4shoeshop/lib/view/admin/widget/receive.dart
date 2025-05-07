import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/view/admin/widget/admin_sales.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

import 'oreturn.dart';
import 'salesmonth.dart';
import 'salestoday.dart';

class ReceivePage extends StatefulWidget {
  const ReceivePage({super.key});

  @override
  State<ReceivePage> createState() => _ReceivePageState();
}

class _ReceivePageState extends State<ReceivePage> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('receivepage'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('신발가게')),
            ListTile(
              title: Text('상품 수령 목록'),
              onTap: () => Get.to(() => ReceivePage()),
            ),
            ListTile(
              title: Text('지점 일매출 현황'),
              onTap: () => Get.to(() => SalestodayPage()),
            ),
            ListTile(
              title: Text('지점 월매출 현황'),
              onTap: () => Get.to(() => SalesmonthPage()),
            ),
            ListTile(
              title: Text('반품 처리 현황'),
              onTap: () => Get.to(() => OreturnPage()),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: fetchOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data![index];
              return Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: getStatusColor(data['ostatus']), // 상태에 따라 색상 변경
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("고객 ID : ${data['ocid']}"),
                    Text("고객 성함 : ${data['cname']}"),
                    Text("주문 번호 : ${data['oid']}"),
                    Text("주문 수량 : ${data['ocount']}개"),
                    Text("주문 일자 : ${data['odate']}"),
                    Text("상태 : ${data['ostatus']}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 상태에 따라 색을 다르게
  Color getStatusColor(dynamic status) {
    if (status == '고객 수령 완료') return Colors.blue.shade100;
    if (status == '수령 전') return Colors.yellow.shade100;
    return Colors.grey.shade200;
  }

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    final db = await handler.initializeDB();
    final result = await db.rawQuery('''
      SELECT o.oid, o.ocid, c.cname, o.ocount, o.odate, o.ostatus
      FROM orders o
      JOIN customer c ON o.ocid = c.cid
    ''');
    return result;
  }
}
