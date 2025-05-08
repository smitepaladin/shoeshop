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
  late List<Map<String, dynamic>> shopSales = [];
  late String selectedDate;

 @override
void initState() {
  super.initState();
  handler = DatabaseHandler();

  final now = DateTime.now();
  selectedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  loadData();
}


  Future<void> loadData() async {
    final result = await handler.getSalesByShop(selectedDate);
    print(result);
    setState(() {
      shopSales = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('지점별 매출 현황')),
      drawer: AdminDrawer(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            TextButton(
  onPressed: () {
    final now = DateTime.now();
    selectedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    loadData();
  },
  child: Text('오늘'),
),
TextButton(
  onPressed: () {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    selectedDate = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
    loadData();
  },
  child: Text('어제'),
),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shopSales.length,
              itemBuilder: (context, index) {
                final data = shopSales[index];
                return ListTile(
                  title: Text('지점: ${data['ename']}'),
                  subtitle: Text('지점 ID: ${data['eid']}'),
                  trailing: Text('${data['total']}원'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}