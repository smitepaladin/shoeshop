import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/model/orders.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:team4shoeshop/view/cart.dart';
import 'package:get_storage/get_storage.dart';

class ShoesDetailPage extends StatefulWidget {
  final Product product;
  const ShoesDetailPage({required this.product, super.key});

  @override
  State<ShoesDetailPage> createState() => _ShoesDetailPageState();
}

class _ShoesDetailPageState extends State<ShoesDetailPage> {
  late DatabaseHandler handler;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  Future<void> _addToCart() async {
    final db = await handler.initializeDB();
    final box = GetStorage();
    final userId = box.read('p_userId') ?? '';

    if (userId.isEmpty) {
      Get.snackbar('오류', '로그인이 필요합니다.');
      return;
    }

    // 현재 날짜를 YYYY-MM-DD 형식으로 가져오기
    final now = DateTime.now();
    final date = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // 장바구니에 상품 추가
    await db.insert('orders', {
      'ocid': userId,
      'opid': widget.product.pid,
      'oeid': 'E001', // 기본 직원 ID
      'ocount': _quantity,
      'odate': date,
      'ostatus': '장바구니',
      'ocartbool': 1,
      'oreturncount': 0,
      'oreturndate': '',
      'oreturnstatus': '',
      'odefectivereason': '',
      'oreason': '',
    });

    Get.snackbar('장바구니', '상품이 장바구니에 추가되었습니다.', duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 상세 내역'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Get.to(() => const CartPage());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상품 이미지
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
                      child: const Center(
                        child: Text(
                          '신발\n이미지',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            // 상품 정보
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('상품명', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.product.pname),
                const Text('브랜드', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.product.pbrand),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('색깔', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.product.pcolor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SIZE', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${widget.product.psize}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('수량', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<int>(
                  value: _quantity,
                  items: List.generate(widget.product.pstock, (i) => i + 1)
                      .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _quantity = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  child: const Text('장바구니 담기'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 즉시구매 기능 구현
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[300],
                  ),
                  child: const Text('즉시구매'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
