import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/model/orders.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class OrderViewPage extends StatefulWidget {
  const OrderViewPage({super.key});

  @override
  State<OrderViewPage> createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {
  late DatabaseHandler handler; // DB 핸들러

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler(); // 핸들러 초기화
  }

  // 주문과 상품 정보를 함께 불러오는 함수
  Future<List<Map<String, dynamic>>> fetchOrderWithProduct() async {
    final orders = await handler.getAllorders(); // 주문 리스트 불러오기
    List<Map<String, dynamic>> result = [];
    for (final order in orders) {
      final product = await handler.getProductByPid(order.opid); // 상품 정보 불러오기
      // 실 상품에 대한 정보를 보여주려면 상품 테이블서 opid로 product를 찾아와야 함
      if (product != null) {
        result.add({'order': order, 'product': product}); // 주문+상품 묶어서 저장
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 주문 내역'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOrderWithProduct(), // 주문+상품 정보 비동기 로딩
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 중
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('주문 내역이 없습니다.'));
          }
          final orderList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              final order = orderList[index]['order'] as Orders; // 주문 정보
              final product = orderList[index]['product'] as Product; // 상품 정보
              final isCompleted = order.ostatus == '고객수령완료'; // 주문 상태 체크
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.yellow[200] : Colors.white, // 완료시 노란색 강조
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 주문일자
                    Text(order.odate, style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // 상품 이미지
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.pink[100],
                          ),
                          child: product.pimage.isNotEmpty
                              ? Image.memory(product.pimage, fit: BoxFit.cover)
                              : Center(child: Text('신발\n이미지', textAlign: TextAlign.center)),
                        ),
                        const SizedBox(width: 12),
                        // 상품 상세 정보
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 상품명, 사이즈, 수량
                              Row(
                                children: [
                                  Text('상품명 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(product.pname),
                                  SizedBox(width: 10),
                                  Text('SIZE ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${product.psize}'),
                                  SizedBox(width: 10),
                                  Text('수량 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${order.ocount}'),
                                ],
                              ),
                              // 브랜드, 색깔
                              Row(
                                children: [
                                  Text('브랜드 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(product.pbrand),
                                  SizedBox(width: 10),
                                  Text('색깔 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(product.pcolor),
                                ],
                              ),
                              // 가격
                              Row(
                                children: [
                                  Text('가격 ', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${product.pprice}원'),
                                ],
                              ),
                              // 주문 상태(고객수령완료 등)
                              if (isCompleted)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    order.ostatus,
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // 하단 홈버튼 (GetX로 뒤로가기)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Get.back(); // 홈으로 이동 (GetX 사용)
          },
          child: Text('홈'),
        ),
      ),
    );
  }
}