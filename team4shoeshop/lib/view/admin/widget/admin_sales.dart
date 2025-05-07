import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/view/admin/oreturn.dart';
import 'package:team4shoeshop/view/admin/receive.dart';
import 'package:team4shoeshop/view/admin/salesmonth.dart';
import 'package:team4shoeshop/view/admin/salestoday.dart';
import 'package:team4shoeshop/vm/database_handler.dart';



class AdminSalesPage extends StatefulWidget {
  const AdminSalesPage({super.key});

  @override
  State<AdminSalesPage> createState() => _AdminSalesPageState();
}

class _AdminSalesPageState extends State<AdminSalesPage> {
  late DatabaseHandler handler;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handler = DatabaseHandler();
  }
  @override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text('상품 관리 시스템')),
drawer: Drawer(
child: ListView(
children: [
DrawerHeader(child: Text('cba 신발 상점')),
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
        future: futureorder(),
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
                  color: Colors.amber,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    (data['ocount'] == null || data['ocount'] == 0)
                    ? "주문 수량이 없습니다."
                    : " 주문 수량 : ${data['oreturncount']}건 있습니다.",
                    ),
                   // Text(), 여기 주문액적을예정 
                    Text(
                (data['oreturncount'] == null || data['oreturncount'] == 0)
                 ? "반품 신청이 없습니다."
                     : "반품 신청 : ${data['oreturncount']}건 있습니다.",)
                  
                  ],
                ),
              );
            },
          );
          }



)
);
}

  Future<List<Map<String, dynamic>>> futureorder() async {
    final db = await handler.initializeDB();
    final result = await db.rawQuery('''
      SELECT o.ocount,o.oreturncount
      FROM orders o
    ''');
    return result;
  }

}
