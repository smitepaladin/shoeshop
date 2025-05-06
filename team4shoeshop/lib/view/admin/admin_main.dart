/*
2025.05.05 이학현 / admin 폴더, admin 로그인 후 넘어오는 메인 화면 생성
*/
import 'package:flutter/material.dart';
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '매장 통합 관리 시스템',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 200,
                      color: Colors.blue[100],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder<int>(
                              future: getLowStockCount(),
                              builder: (context, snapshot) {
                                return Text(
                                  snapshot.hasData
                                    ? "재고가 30개 미만인 상품이 ${snapshot.data}개 있습니다."
                                    : "불러오는 중...",
                                    textAlign: TextAlign.center,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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