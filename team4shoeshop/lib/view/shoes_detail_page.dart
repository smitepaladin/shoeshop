import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/model/orders.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:get_storage/get_storage.dart';
import 'buy.dart';
import 'cart.dart';

class ShoesDetailPage extends StatefulWidget {
  final Product product;
  
  const ShoesDetailPage({required this.product, super.key});

  @override
  State<ShoesDetailPage> createState() => _ShoesDetailPageState();
}

class _ShoesDetailPageState extends State<ShoesDetailPage> {
  int selectedQuantity = 1;
  final DatabaseHandler handler = DatabaseHandler();
  final box = GetStorage();

  Future<void> _addToCart() async {
    final cid = box.read('p_userId');
    if (cid == null) {
      Get.snackbar(
        '알림',
        '로그인이 필요합니다.',
        duration: Duration(seconds: 2)
        );
      return;
    }

    final db = await handler.initializeDB();
    await db.insert('orders', {
      'ocid': cid,
      'opid': widget.product.pid,
      'oeid': '', // 직원은 아직 미지정
      'ocount': selectedQuantity,
      'odate': DateTime.now().toIso8601String(),
      'ostatus': '장바구니',
      'ocartbool': 1,
      'oreturncount': 0,
      'oreturndate': '',
      'oreturnstatus': '',
      'odefectivereason': '',
      'oreason': '',
    });

    Get.snackbar('성공', '장바구니에 추가되었습니다.', duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 상세'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Get.to(() => CartPage()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: widget.product.pimage.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        widget.product.pimage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Container(
                      color: Colors.pink[100],
                      child: Center(
                        child: Text(
                          '신발\n이미지',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('상품명', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.product.pname),
                Text('브랜드', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.product.pbrand),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('색깔', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.product.pcolor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SIZE', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${widget.product.psize}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('수량', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<int>(
                  value: selectedQuantity,
                  items: List.generate(widget.product.pstock, (i) => i + 1)
                      .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedQuantity = value;
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${widget.product.pprice}원'),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[100],
                  ),
                  child: Text('장바구니 담기'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const BuyPage(), arguments: {
                      'product': widget.product,
                      'quantity': selectedQuantity,
                    });
                  },
                  child: const Text("구매하기"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
