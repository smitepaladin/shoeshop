import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:team4shoeshop/view/admin/widget/admin_drawer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class AdminAddApproval extends StatefulWidget {
  const AdminAddApproval({super.key});

  @override
  State<AdminAddApproval> createState() => _AdminAddApprovalState();
}

class _AdminAddApprovalState extends State<AdminAddApproval> {
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
    appBar: AppBar(
      title: Text(
          '품의서',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
    ),
    drawer: AdminDrawer(),
    body: Column(
      children: [
        Expanded(
          child: FutureBuilder<List<String>>(
            future: getApproval(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('에러 발생: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final approval = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          approval,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('데이터 없음'));
              }
            },
          ),
        ),
      ],
    ),
  );
} // build

Future<List<String>> getApproval() async {
  final Database db = await handler.initializeDB();
  final result = await db.rawQuery('select a.astatus, p.pbrand, p.pname, p.pcolor, p.psize, a.abaljoo, a.adate from product p, approval a where a.apid=p.pid');
  return result.map((e) => "${e['astatus']} | ${e['pbrand']} | ${e['pname']} | ${e['pcolor']} | ${e['psize']} | ${e['abaljoo']} | ${e['adate']}").toList();
}

} // class