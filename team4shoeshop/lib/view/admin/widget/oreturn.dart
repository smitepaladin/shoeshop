import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../vm/database_handler.dart';

class OreturnPage extends StatefulWidget {
  const OreturnPage({super.key});

  @override
  State<OreturnPage> createState() => _OreturnPageState();
}

class _OreturnPageState extends State<OreturnPage> {
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
        title:   ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('전체 재고 현황'),
            onTap: () {
              Get.back();
            },
          ),
      ),
      body: FutureBuilder(
        future: fetchOrders(), //Db에서 받아오는정보들
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('반품 요청이 없습니다.'));
  }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data![index];
              return Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: getStatusColor(data['ostatus']), //ostatus의 상태에따라 색이다름
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
                    Text("반품사유 : ${data['oreason']}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
//상태에따라 색을다르게함
Color getStatusColor(dynamic status) {
  if (status == '반품 완료') return Colors.blue.shade100;
  if (status == '반송') return const Color.fromARGB(255, 198, 94, 131);
  if (status == '접수') return Colors.yellow.shade100;
  return Colors.grey.shade200;
}
Future<List<Map<String, dynamic>>> fetchOrders() async {
  final db = await handler.initializeDB();
  final result = await db.rawQuery('''
    SELECT o.oid, o.ocid, c.cname, o.ocount, o.odate, o.ostatus, o.oreason
    FROM orders o
    JOIN customer c ON o.ocid = c.cid
    WHERE o.ostatus IN ('반품 완료', '반송', '접수')
  ''');
  return result;
}
  

}
