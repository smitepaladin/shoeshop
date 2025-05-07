import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:team4shoeshop/view/admin/widget/admin_drawer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class AdminReturn extends StatefulWidget {
  const AdminReturn({super.key});

  @override
  State<AdminReturn> createState() => _AdminReturnState();
}

class _AdminReturnState extends State<AdminReturn> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: AdminDrawer(),
          ),
Flexible(
  child: Container(
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 상단 제목 텍스트
        Padding(
          padding: const EdgeInsets.all(20.0),
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
      ],
    ),
  ),
),
        ],
      ),
    );
  } // build

  Future<int> getLowStockCount() async {
  final db = await handler.initializeDB();
  final result = await db.rawQuery('select count(*) as cnt from product where pstock < 30');
  return Sqflite.firstIntValue(result) ?? 0;
}

} // class