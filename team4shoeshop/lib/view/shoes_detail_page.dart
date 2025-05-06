import 'package:flutter/material.dart';
import 'package:team4shoeshop/model/product.dart';

class ShoesDetailPage extends StatelessWidget {
  final Product product; // 상품
  const ShoesDetailPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상품 상세'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상품 이미지
            Expanded(
              child:
                  product.pimage.isNotEmpty
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
            // 상품 정보
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
                // 수량 선택 드롭다운(예시)
                DropdownButton<int>(
                  value: 1,
                  items:
                      List.generate(product.pstock, (i) => i + 1)
                          .map(
                            (e) =>
                                DropdownMenuItem(value: e, child: Text('$e')),
                          )
                          .toList(),
                  onChanged: (v) {},
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${product.pprice}원'),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 장바구니 담기 기능 구현
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[100],
                  ),
                  child: Text('장바구니 담기'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 즉시구매 기능 구현
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[300],
                  ),
                  child: Text('즉시구매'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
