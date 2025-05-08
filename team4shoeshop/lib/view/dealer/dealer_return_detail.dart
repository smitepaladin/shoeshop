import 'package:flutter/material.dart';
import 'package:team4shoeshop/view/dealer/dealer_widget/dealer_widget.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class DealerReturnDetail extends StatefulWidget {
  final Map<String, dynamic> orderMap;

  const DealerReturnDetail({super.key, required this.orderMap});

  @override
  State<DealerReturnDetail> createState() => _DealerReturnDetailState();
}

class _DealerReturnDetailState extends State<DealerReturnDetail> {
  final handler = DatabaseHandler();

  late TextEditingController returnCountController;
  late TextEditingController reasonController;
  late TextEditingController statusController;
  late TextEditingController defectiveReasonController;

  @override
  void initState() {
    super.initState();
    returnCountController = TextEditingController(
        text: widget.orderMap['oreturncount']?.toString() ?? '');
    reasonController =
        TextEditingController(text: widget.orderMap['oreason'] ?? '');
    statusController =
        TextEditingController(text: widget.orderMap['oreturnstatus'] ?? '');
    defectiveReasonController = TextEditingController(
        text: widget.orderMap['odefectivereason'] ?? '');
  }

Future<void> updateReturnInfo() async {
  final db = await handler.initializeDB();

  // 저장 누르는 순간 현재 날짜를 yyyy-MM-dd 형식으로 생성
  final now = DateTime.now();
  final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

  await db.update(
    'orders',
    {
      'oreturncount': int.tryParse(returnCountController.text) ?? 0,
      'oreason': reasonController.text,
      'oreturnstatus': statusController.text,
      'odefectivereason': defectiveReasonController.text,
      'oreturndate': formattedDate, // ✅ 저장 시 즉시 yyyy-MM-dd 형태로 입력
    },
    where: 'oid = ?',
    whereArgs: [widget.orderMap['oid']],
  );

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('반품 정보가 저장되었습니다')),
    );
    Navigator.pop(context);
  }
  setState(() {});
}


  @override
  Widget build(BuildContext context) {
    final order = widget.orderMap;

    return Scaffold(
      appBar: AppBar(
        title: const Text('반품 정보 수정'),
      ),
      drawer: DealerDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('상품명: ${order['pname']}'),
            Text('주문일: ${order['odate']}'),
            Text('주문수량: ${order['ocount']}'),
            const SizedBox(height: 20),
            TextField(
              controller: returnCountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '반품 수량'),
            ),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: '반품 사유'),
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(labelText: '반품 상태'),
            ),
            TextField(
              controller: defectiveReasonController,
              decoration: const InputDecoration(labelText: '원인 규명'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateReturnInfo,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
