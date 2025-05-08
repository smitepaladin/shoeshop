import 'package:flutter/material.dart';
import 'package:team4shoeshop/view/admin/widget/admin_drawer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class AdminSales extends StatefulWidget {
  const AdminSales({super.key});

  @override
  State<AdminSales> createState() => _AdminSalesState();
}

class _AdminSalesState extends State<AdminSales> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }


// GPT 테스트 주석
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('판매 현황 통계')),
      drawer: AdminDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadShopSalesForTwoDays(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final salesData = snapshot.data!;
          final yesterday = DateTime.now().subtract(Duration(days: 1));
          final today = DateTime.now();

          final yDate = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
          final tDate = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue[100],
                padding: EdgeInsets.all(8),
                child: Text(
                  '• 각 지점별 현황: 지점명 | 어제 날짜 매출 | 오늘 날짜 매출',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: salesData.length,
                  itemBuilder: (context, index) {
                    final item = salesData[index];
                    return Card(
                      color: Colors.blue[50],
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ${item['ename']} | $yDate | $tDate'),
                            SizedBox(height: 4),
                            Text('${item['yesterday']}원 | ${item['today']}원'),
                          ],
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
  }

  Future<List<Map<String, dynamic>>> loadShopSalesForTwoDays() async {
    final db = await handler.initializeDB();

    final today = DateTime.now();
    final yesterday = today.subtract(Duration(days: 1));

    final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final yestStr = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

    final yestResult = await handler.getSalesByShop(yestStr);
    final todayResult = await handler.getSalesByShop(todayStr);

    final Map<String, int> yMap = { for (var e in yestResult) e['eid']: e['total'] as int };
    final Map<String, int> tMap = { for (var e in todayResult) e['eid']: e['total'] as int };
    final Map<String, String> nameMap = { for (var e in [...yestResult, ...todayResult]) e['eid']: e['ename'] };

    final Set<String> allEids = {...yMap.keys, ...tMap.keys};

    return allEids.map((eid) => {
      'eid': eid,
      'ename': nameMap[eid] ?? '',
      'yesterday': yMap[eid] ?? 0,
      'today': tMap[eid] ?? 0,
    }).toList();
  }
}
