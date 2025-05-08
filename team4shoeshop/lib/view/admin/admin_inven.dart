import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/view/admin/admin_approval.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:team4shoeshop/view/admin/widget/admin_drawer.dart';

class AdminInven extends StatefulWidget {
  const AdminInven({super.key});

  @override
  State<AdminInven> createState() => _AdminInvenState();
}

class _AdminInvenState extends State<AdminInven> {
  late DatabaseHandler handler;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    String adminId = box.read('adminId') ?? '_';
    int adminPermission = box.read('adminPermission')?.toInt() ?? 0;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(AdminApproval());
            }, 
            icon: Icon(Icons.approval)
          ),
        ],
        title: Column(
          children: [
            Text('전체 상품 재고 현황'),
            Text('관리자 ID:$adminId, 권한 등급: $adminPermission', style: TextStyle(fontSize: 15),)
          ],
        ), 
      ),
      drawer: AdminDrawer(), 
      body: FutureBuilder<List<Product>>( 
        future: handler.fetchInventory(), // DatabaseHandler의 메서드 사용
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          // 데이터가 로딩되었으면 리스트 생성
          final products = snapshot.data!;
          
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              // 재고 수량이 30개 이하인 경우 위험 표시용 플래그
              final isLowStock = product.pstock <= 30;

              return Card(
                // 재고 적은 상품은 배경을 붉은색으로 표시
                color: isLowStock ? Colors.redAccent : Colors.white10,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단: 브랜드명과 재고 수량 표시 (오른쪽 정렬)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.pbrand, // 브랜드명
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isLowStock ? Colors.red[100] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '재고: ${product.pstock}개', // 재고 수량
                              style: TextStyle(
                                color: isLowStock ? Colors.black : Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      // 상품명, 색상, 사이즈 정보 출력
                      Text('상품명: ${product.pname}'),
                      SizedBox(height: 3),
                      Text('색상: ${product.pcolor}'),
                      SizedBox(height: 3),
                      Text('사이즈: ${product.psize}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
