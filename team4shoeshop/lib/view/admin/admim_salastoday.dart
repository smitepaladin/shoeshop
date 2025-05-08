import 'package:flutter/material.dart';
import 'package:team4shoeshop/view/admin/widget/admin_drawer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class SalastodayPage extends StatefulWidget {
  const SalastodayPage({super.key});

  @override
  State<SalastodayPage> createState() => _SalastodayPageState();
}

class _SalastodayPageState extends State<SalastodayPage> {
  late DatabaseHandler handler;
  late List<Map<String, dynamic>> shopSales = [];
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    selectedDate = '2025-04-10'; // 기본값: 화면에보이는값
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
        appBar: AppBar(
      title: Text(
          '지점별 매출현황',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
    ),
    drawer: AdminDrawer(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
TextButton(
  onPressed: () {
    selectedDate = DateTime.now().toString().substring(0, 10); // 오늘 날짜 자동
  
    loadData();    // 매출 불러오기
  },
                  
                 
                
                child: Text('오늘'),
              ),
              TextButton(
                onPressed: () {
                  selectedDate = '2025-04-10'; // 어제
                    
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
                return Container(        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 바깥 여백
        padding: EdgeInsets.all(16), // 안쪽 여백
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
        ),
                  child: ListTile(
                    title: Text('지점: ${data['ename']}'),
                    subtitle: Text('지점 ID: ${data['eid']}'),
                    trailing: Text('${data['total']}원'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}