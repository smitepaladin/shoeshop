import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class AdminDailyRevenue extends StatefulWidget {
  const AdminDailyRevenue({super.key});

  @override
  State<AdminDailyRevenue> createState() => _AdminDailyRevenueState();
}

class _AdminDailyRevenueState extends State<AdminDailyRevenue> {
  late DatabaseHandler handler;
  List<DailyRevenue> chartData = [];

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    final db = await handler.initializeDB();
    final result = await db.rawQuery('''
      SELECT 
        substr(o.odate, 1, 10) as date,
        sum(p.pprice * o.ocount) as total
      FROM orders o
      JOIN product p ON o.opid = p.pid
      WHERE o.ostatus = '결제완료'
      GROUP BY date
      ORDER BY date
    ''');

    setState(() {
      chartData =
          result.map((row) {
            return DailyRevenue(
              date: row['date'] as String,
              amount: (row['total'] as int) ~/ 10000,
            );
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('일자별 매출 현황')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('• 모든 일자별 매출 현황', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(title: AxisTitle(text: '단위: 만원')),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  ColumnSeries<DailyRevenue, String>(
                    dataSource: chartData,
                    xValueMapper: (DailyRevenue data, _) => data.date,
                    yValueMapper: (DailyRevenue data, _) => data.amount,
                    color: Colors.orange,
                    name: '매출',
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
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
