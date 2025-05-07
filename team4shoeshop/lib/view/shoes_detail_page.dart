import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/model/product.dart';
import 'buy.dart';

class ShoesDetailPage extends StatefulWidget {
  final Product product;

  const ShoesDetailPage({super.key, required this.product});

  @override
  State<ShoesDetailPage> createState() => _ShoesDetailPageState();
}

class _ShoesDetailPageState extends State<ShoesDetailPage> {
  int selectedCount = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text('상품 상세'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상품 이미지
            Expanded(
              child: product.pimage.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        product.pimage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Container(
                      color: Colors.pink[100],
                      child: const Center(
                        child: Text('신발\n이미지',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('상품명', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(product.pname),
                Text('브랜드', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(product.pbrand),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('색깔', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(product.pcolor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SIZE', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${product.psize}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('수량', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<int>(
                  value: selectedCount,
                  items: List.generate(product.pstock, (i) => i + 1)
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        selectedCount = v;
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
                Text('${product.pprice * selectedCount}원'),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 장바구니 담기 기능 구현 예정
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[100],
                  ),
                  child: const Text('장바구니 담기'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const BuyPage(), arguments: {
                      'product': product,
                      'count': selectedCount, // 구매 수량도 전달
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
