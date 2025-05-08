import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class AdminGoodsRevenue extends StatefulWidget {
  const AdminGoodsRevenue({super.key});

  @override
  State<AdminGoodsRevenue> createState() => _AdminGoodsRevenueState();
}

class _AdminGoodsRevenueState extends State<AdminGoodsRevenue> {
  late DatabaseHandler handler;
  List<GoodsRevenue> chartData = [];

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
        p.pname as name,
        SUM(p.pprice * o.ocount) as total
      FROM orders o
      JOIN product p ON o.opid = p.pid
      WHERE o.ostatus = '결제완료'
      GROUP BY p.pname
      ORDER BY total DESC
    ''');

    setState(() {
      chartData = result.map((row) {
        return GoodsRevenue(
          name: row['name'] as String,
          amount: (row['total'] as int) ~/ 10000, // 만원 단위로 변환
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품별 매출 현황'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // 또는 Get.back();
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('• 모든 상품별 매출 현황', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelRotation: -20,
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: '단위: 만원'),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  LineSeries<GoodsRevenue, String>(
                    dataSource: chartData,
                    xValueMapper: (GoodsRevenue data, _) => data.name,
                    yValueMapper: (GoodsRevenue data, _) => data.amount,
                    markerSettings: const MarkerSettings(isVisible: true),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    color: Colors.purple,
                    name: '매출',
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

class GoodsRevenue {
  final String name;
  final int amount;

  GoodsRevenue({required this.name, required this.amount});
}
