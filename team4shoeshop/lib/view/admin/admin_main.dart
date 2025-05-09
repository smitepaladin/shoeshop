/*
2025.05.05 이학현 / admin 폴더, admin 로그인 후 넘어오는 메인 화면 생성
*/
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:team4shoeshop/view/admin/widget/admin_drawer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';


class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  late DatabaseHandler handler;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AdminDrawer(),
          appBar: AppBar(
      title: Text(
          '매장 통합 관리 시스템',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
    ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
Container(
  color: Colors.white,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // 중앙 콘텐츠
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 60),
        child: SizedBox(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue[100]
              ),
              height: 80,
              width: 300,
              child: Center(
                child: FutureBuilder<int>(
                  future: getLowStockCount(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.hasData
                        ? "재고가 30개 미만인 상품이 ${snapshot.data}개 있습니다."
                        : "불러오는 중...",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        child: Center(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue[100]
              ),
            height: 80,
            width: 300,
            child: Center(
              child: FutureBuilder<List<int>>(
                future: Future.wait([
                  getTodaySales(),
                  getYesterdaySales(),
                ]),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData
                      ? "전일 매출은 ${snapshot.data![1]}원 입니다.\n금일 매출은 ${snapshot.data![0]}원 입니다."
                      : "불러오는 중...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 60, 0, 60),
        child: SizedBox(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue[100]
              ),
              height: 80,
              width: 300,
              child: Center(
                child: FutureBuilder<int>(
                  future: getapprovalCount(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.hasData
                        ? "결재할 문서가 ${snapshot.data!}건 있습니다."
                        : "불러오는 중...",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        child: Center(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue[100]
              ),
            height: 80,
            width: 300,
            child: Center(
              child: FutureBuilder<int>(
                future: getReturnCount(),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData
                      ? "반품 접수가 ${snapshot.data!}건 있습니다."
                      : "불러오는 중...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),
        ],
      ),
    );
  } // build

Future<int> getLowStockCount() async {
  final Database db = await handler.initializeDB();
  final result = await db.rawQuery('select count(*) from product where pstock < 30');
  return Sqflite.firstIntValue(result) ?? 0;
}

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

Future<int> getapprovalCount() async {
  final Database db = await handler.initializeDB();
  final adminPermission = box.read('adminPermission');
  int count = 0;
  if (adminPermission == 2) {
    final result = await db.rawQuery('select count(*) from approval a where a.astatus = "대기"');
    count = Sqflite.firstIntValue(result) ?? 0;
  } else if (adminPermission == 3) {
    final result = await db.rawQuery('select count(*) from approval a where a.astatus = "팀장승인"');
    count = Sqflite.firstIntValue(result) ?? 0;
  }
  return count;
}

Future<int> getReturnCount() async {
  final Database db = await handler.initializeDB();
  final result = await db.rawQuery('select count(*) from orders where oreturnstatus = "요청"');
  return Sqflite.firstIntValue(result) ?? 0;
}
} // class