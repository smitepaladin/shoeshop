import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:team4shoeshop/view/admin/widget/admin_drawer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class AdminInven extends StatefulWidget {
  const AdminInven({super.key});

  @override
  State<AdminInven> createState() => _AdminInvenState();
}

class _AdminInvenState extends State<AdminInven> {
  late DatabaseHandler handler;

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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
Container(
  color: Colors.white,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // 상단 제목 텍스트
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Text(
          '매장 통합 관리 시스템',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      // 중앙 콘텐츠
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 60),
        child: SizedBox(
          child: Center(
            child: Container(
              height: 80,
              width: 300,
              color: Colors.blue[100],
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
            height: 80,
            width: 300,
            color: Colors.blue[100],
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
              height: 80,
              width: 300,
              color: Colors.blue[100],
              child: Center(
                child: FutureBuilder<int>(
                  future: getLowStockCount(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.hasData
                        ? "결재할 문서가 건 있습니다."
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
            height: 80,
            width: 300,
            color: Colors.blue[100],
            child: Center(
              child: FutureBuilder<int>(
                future: getLowStockCount(),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData
                      ? "반품 접수가 건 있습니다."
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
} // class