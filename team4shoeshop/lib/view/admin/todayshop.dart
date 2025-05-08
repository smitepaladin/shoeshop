import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../vm/database_handler.dart';

class TodayshopPage extends StatefulWidget {
  const TodayshopPage({super.key});

  @override
  State<TodayshopPage> createState() => _TodayshopPageState();
}

class _TodayshopPageState extends State<TodayshopPage> {
  late DatabaseHandler handler;
  late List<Map<String, dynamic>> shopSales = [];
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    selectedDate = '2025-04-10'; // 기본값: 오늘
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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  selectedDate = '2025-04-10'; // 오늘
                  loadData();
                },
                child: Text('오늘'),
              ),
              TextButton(
                onPressed: () {
                  selectedDate = '2025-05-04'; // 어제
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