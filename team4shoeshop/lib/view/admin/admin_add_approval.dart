import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:team4shoeshop/model/approval.dart';
import 'package:team4shoeshop/view/admin/admin_approval.dart';
import 'package:team4shoeshop/view/admin/widget/admin_drawer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class AdminAddApproval extends StatefulWidget {
  const AdminAddApproval({super.key});

  @override
  State<AdminAddApproval> createState() => _AdminAddApprovalState();
}

class _AdminAddApprovalState extends State<AdminAddApproval> {
  late DatabaseHandler handler;
  late String selectedProduct; // 드롭다운에서 선택한 상품
  late TextEditingController controller; // 수량 입력
  List<String> productList = []; // 재고 30개 미만 상품명

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    controller = TextEditingController();
    selectedProduct = "";
    loadProducts();
  }

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            '품의서',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            DropdownButton(
              hint: Text('선택'),
              items: productList.map((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                );
              }).toList(), 
              onChanged: (value) {
                selectedProduct = value!;
                setState(() {});
              },
            ),
          ],
      ),
      drawer: AdminDrawer(),
    body: Center(
    child: selectedProduct == null
        ? Text('상품을 선택하세요')
        : Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 80),
              child: Text("브랜드 | 상품명 | 색상 | 사이즈 | 재고"),
            ),
            Container(
              color: Colors.blue[50],
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: FutureBuilder<List<String>>(
                    future: getLowStockProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('에러: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('상품을 선택해 주세요');
                      } else {
                        return Text('선택된 상품: ${snapshot.data![0]}');
                      }
                    },
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(100, 20, 100, 20),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '수량',
                  hintText: '주문할 수량을 입력해 주세요'
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if(selectedProduct == "" || controller.text.isEmpty){
                  Get.snackbar(
                    '전송 할 수 없습니다', '상품과 수량을 입력해 주세요',
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.redAccent);
                }else{
                insertAction();
                Get.off(AdminApproval());
                Get.snackbar('전송 성공', '품의서를 전송했습니다');
                }
              }, 
              child: Text('전송'),
            ),
          ],
        ),
    ),
    ),
  );
} // build

  // Future<List<String>> getLowStockProducts() async {
  //   final Database db = await handler.initializeDB();
  //   final result = await db.rawQuery('select pname from product where pstock < 30');
  //   return result.map((e) => e['pname'] as String).toList();
  // }

  Future<void> loadProducts() async {
    final db = await handler.initializeDB();
    final result = await db.rawQuery('select pname from product where pstock < 30');
    setState(() {
      productList = result.map((e) => e['pname'] as String).toList();
    });
  }

  Future<List<String>> getLowStockProducts() async {
  final Database db = await handler.initializeDB();
  final result = await db.rawQuery('select p.pbrand, p.pname, p.pcolor, p.psize, p.pstock from product p where p.pname="$selectedProduct"');
  return result.map((e) => "${e['pbrand']} | ${e['pname']} | ${e['pcolor']} | ${e['psize']} | ${e['pstock']}").toList();
}

  Future<int> insertApproval(Approval approval) async{
    int result = 0;
    final Database db = await handler.initializeDB();

    result = await db.rawInsert(
      'insert into approval(aeid, afid, apid, abaljoo, asoojoo, astatus, adate, ateamappdate, achiefappdate) values (?,?,?,?,?,?,?,?,?)',
      [approval.aeid, approval.afid, approval.apid, approval.abaljoo, approval.asoojoo, approval.astatus, approval.adate, approval.ateamappdate, approval.achiefappdate]
    );
    return result;
  }
  

  insertAction()async{
    var approvalInsert = Approval(
      aeid: '', 
      afid: (await getFidByProductName(selectedProduct))!, 
      abaljoo: int.parse(controller.text), 
      asoojoo: 0, 
      astatus: '대기', 
      adate: "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}", 
      ateamappdate: '', 
      achiefappdate: '', 
      apid: (await getPidByProductName(selectedProduct))!,
    );
    int result = await insertApproval(approvalInsert);
  }

  Future<String?> getPidByProductName(String pname) async {
  final db = await handler.initializeDB();
  final result = await db.rawQuery(
    'select pid from product where pname = ?',
    [pname],
  );
  if (result.isNotEmpty) {
    return result.first['pid'] as String;
  } else {
    return null;
  }
}

  Future<String?> getFidByProductName(String pname) async {
  final db = await handler.initializeDB();
  final result = await db.rawQuery(
    'select fid from product p, factory f where pname = ? and pbrand = fbrand',
    [pname],
  );
  if (result.isNotEmpty) {
    return result.first['fid'] as String;
  } else {
    return null;
  }
}
} // class