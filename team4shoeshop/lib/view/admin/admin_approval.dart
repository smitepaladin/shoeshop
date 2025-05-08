import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:team4shoeshop/view/admin/admin_add_approval.dart';
import 'package:team4shoeshop/view/admin/widget/admin_drawer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class AdminApproval extends StatefulWidget {
  const AdminApproval({super.key});

  @override
  State<AdminApproval> createState() => _AdminApprovalState();
}

class _AdminApprovalState extends State<AdminApproval> {
  late DatabaseHandler handler;
  final box = GetStorage();
  
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
          '품의 및 결재',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final adminPermission = box.read('adminPermission');
              if(adminPermission == 1){
                Get.to(AdminAddApproval())?.then((value) => setState(() {}));
              }else{
                Get.snackbar(
                  '권한 불일치', '권한이 없습니다.',
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.redAccent
                );
              }
            }, 
            icon: Icon(Icons.add),
          ),
        ],
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
                    final parts = approval.split(' | ');
                    final aid = int.parse(parts[0].toString().substring(8));
                    final status = parts[1];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: BehindMotion(), 
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.redAccent,
                            icon: Icons.block,
                            label: '반려',
                            onPressed: (context) {
                              final adminPermission = box.read('adminPermission');
                              if(adminPermission==1){
                                Get.snackbar(
                                  '권한 불일치', '권한이 없습니다.',
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.redAccent
                                );
                              }else{
                                selectDelete(aid);
                              }
                            }, 
                          ),
                        ],
                      ),
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        color: status=='임원승인'?Colors.grey:Colors.blue[50],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  approval,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final adminPermission = box.read('adminPermission');
                                  if(status=='대기'){
                                    if(adminPermission==2){
                                      Get.defaultDialog(
                                        title: '해당 건을 결재하시겠습니까?',
                                        content: Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => Get.back(), 
                                              child: Text('취소'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async{
                                                await update2Approval(aid);
                                                setState(() {});
                                                Get.back();
                                              }, 
                                              child: Text('결재'),
                                            ),
                                          ],
                                        )
                                      );
                                    }else{
                                      Get.snackbar(
                                        '권한 불일치', '권한이 없습니다.',
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.redAccent
                                      );
                                    }
                                  }
                                  if(status=='팀장승인'){
                                    if(adminPermission==3){
                                      Get.defaultDialog(
                                        title: '해당 건을 결재하시겠습니까?',
                                        content: Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => Get.back(), 
                                              child: Text('취소'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async{
                                                await updateApprovalAndStockWithErrorHandling(aid);
                                                setState(() {});
                                                Get.back();
                                              }, 
                                              child: Text('결재'),
                                            ),
                                          ],
                                        )
                                      );
                                    }else{
                                      Get.snackbar(
                                        '권한 불일치', '권한이 없습니다.',
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.redAccent
                                      );
                                    }
                                  }
                                }, 
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: status=='임원승인'?Colors.grey:Colors.white
                                ),
                                child: Text('결재'),
                              ),
                            ],
                          ),
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

  selectDelete(aid){
    showCupertinoModalPopup(
      context: context, 
      barrierDismissible: false,
      builder: (context) => CupertinoActionSheet(
        title: Text('경고',
        style: TextStyle(
          color: Colors.red
        ),),
        message: Text('선택한 항목을 삭제하시겠습니까?',
        style: TextStyle(
          color: Colors.red
        ),),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              deleteApproval(aid); // 리스트에서 삭제
              setState(() {}); // 삭제된 거 화면에 반영
              Get.back(); // 액션시트 치우기
            }, 
            child: Text('삭제',
            style: TextStyle(
              color: Colors.red
            ),),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Get.back(), 
          child: Text('취소'),
        ),
      ),
    );
  }

Future<List<String>> getApproval() async {
  final Database db = await handler.initializeDB();
  final result = await db.rawQuery('select a.aid, a.astatus, p.pbrand, p.pname, p.pcolor, p.psize, a.abaljoo, a.adate, p.pstock from product p, approval a where a.apid=p.pid order by aid');
  return result.map((e) => "문서 번호 : ${e['aid']} | ${e['astatus']} | ${e['pbrand']}\n${e['pname']} | ${e['pcolor']} | ${e['psize']} | ${e['abaljoo']}\n${e['adate']} | 현재 재고 : ${e['pstock']}").toList();
}

    Future<int> update2Approval(int aid) async{
    int result = 0;
    final Database db = await handler.initializeDB();
    result = await db.rawUpdate(
      'update approval set astatus = ?, ateamappdate = ? where aid = ?',
      ['팀장승인', "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",aid]
    );
    return result;
  }

      Future<int> update3Approval(int aid) async{
    int result = 0;
    final Database db = await handler.initializeDB();
    result = await db.rawUpdate(
      'update approval set astatus = ?, achiefappdate = ? where aid = ?',
      ['임원승인', "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",aid]
    );
    return result;
  }

  // Future<int> updateStock(int aid) async{
  //   int result = 0;
  //   final Database db = await handler.initializeDB();
  //   result = await db.rawUpdate(
  //     'update approval set astatus = ?, achiefappdate = ? where aid = ?',
  //     ['임원승인', "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",aid]
  //   );
  //   return result;
  // }
  Future<void> updateApprovalAndStockWithErrorHandling(int aid) async {
  final db = await handler.initializeDB();

    // 1. approval 테이블에서 apid, abaljoo 가져오기
    final approval = await db.query(
      'approval',
      columns: ['apid', 'abaljoo'],
      where: 'aid = ?',
      whereArgs: [aid],
    );

    if (approval.isEmpty) {
      throw Exception('해당 approval(aid: $aid)을 찾을 수 없습니다.');
    }

    final pid = approval.first['apid'] as String;
    final abaljoo = approval.first['abaljoo'] as int;

    // 2. approval 상태 및 achiefappdate 업데이트
    final approvalUpdate = await db.rawUpdate(
      'UPDATE approval SET astatus = ?, achiefappdate = ? WHERE aid = ?',
      [
        '임원승인',
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
        aid
      ],
    );

    if (approvalUpdate == 0) {
      throw Exception('Approval 테이블 업데이트 실패');
    }

    // 3. product 테이블의 pstock 증가
    final stockUpdate = await db.rawUpdate(
      'UPDATE product SET pstock = pstock + ? WHERE pid = ?',
      [abaljoo, pid],
    );

    if (stockUpdate == 0) {
      throw Exception('Product 테이블 업데이트 실패');
    }
  }

    Future<void> deleteApproval(aid) async{
    final Database db = await handler.initializeDB();
    await db.rawDelete('delete from approval where aid = ?', [aid]);
  }
  
} // class