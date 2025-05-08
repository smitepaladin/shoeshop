import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/dealer/dealer_widget/dealer_widget.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class DealerMain extends StatefulWidget {
  const DealerMain({super.key});

  @override
  State<DealerMain> createState() => _DealerMainState();
}

class _DealerMainState extends State<DealerMain> {
  final box = GetStorage();
  final handler = DatabaseHandler();
  

  List<DailyRevenue> chartData = [];
  String districtName = '';
  int totalRevenue = 0;
 

  late final String currentYM;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentYM = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    fetchDistrictName();
    fetchDealerRevenue();
  }

  Future<void> fetchDistrictName() async {
    final db = await handler.initializeDB();
    final String eid = box.read('adminId') ?? '';

    final result = await db.query(
      'employee',
      columns: ['ename'],
      where: 'eid = ?',
      whereArgs: [eid],
    );

    if (result.isNotEmpty) {
      setState(() {
        districtName = result.first['ename']?.toString() ?? '';
      });
    }
  }

  Future<void> fetchDealerRevenue() async {
    final db = await handler.initializeDB();
    final String eid = box.read('adminId') ?? '';

    final result = await db.rawQuery('''
      SELECT substr(o.odate, 1, 10) as date, SUM(p.pprice * o.ocount) as total
      FROM orders o
      JOIN product p ON o.opid = p.pid
      WHERE o.oeid = ? AND o.ostatus = '결제완료'
        AND substr(o.odate, 1, 7) = ?
      GROUP BY date
      ORDER BY date
    ''', [eid, currentYM]);

    final List<DailyRevenue> newData = result.map((row) {
      return DailyRevenue(
        date: row['date']?.toString() ?? '',
        amount: (row['total'] as int) ~/ 10000, // 만원 단위
      );
    }).toList();

    final int sum = newData.fold(0, (prev, item) => prev + item.amount);

    setState(() {
      chartData = newData;
      totalRevenue = sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DealerDrawer(),
      appBar: AppBar(
        title: Text(
          '[$districtName] $currentYM 매출 현황',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: chartData.isEmpty
            ? const Center(child: Text('이번 달의 매출이 없습니다.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이번 달 총 매출: $totalRevenue 만원',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: chartData.length,
                      itemBuilder: (context, index) {
                        final data = chartData[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: Text(data.date),
                            trailing: Text('${data.amount} 만원'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class DailyRevenue {
  final String date;
  final int amount;

  DailyRevenue({required this.date, required this.amount});
}
