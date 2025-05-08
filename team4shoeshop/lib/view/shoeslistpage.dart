import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/view/edit_profile_page.dart';
import 'package:team4shoeshop/view/location_search.dart';
import 'package:team4shoeshop/view/returns.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'package:team4shoeshop/view/shoes_detail_page.dart';
import 'package:team4shoeshop/view/orderviewpage.dart';

import 'cart.dart';

// 다른 페이지에서도 사용용 가능한 Drawer 위젯
class MainDrawer extends StatelessWidget {
  final box = GetStorage();
  MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = box.read('p_userId') ?? '';
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userId.isNotEmpty ? userId : '로그인 필요'),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('상품 구매'),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('회원정보 수정'),
            onTap: () {
              Get.to(() => EditProfilePage());
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('내 주문 내역'),
            onTap: () {
              Get.to(() => OrderViewPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('장바구니'),
            onTap: () {
              Get.to(() => CartPage());
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('위치 검색'),
            onTap: () {
              Get.to(() => LocationSearch());
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_return),
            title: Text('반품 내역 확인'),
            onTap: () {
              Get.to(() => Returns());
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('로그아웃'),
            onTap: () {
              box.erase();
              Get.offAllNamed('/'); // 첫 화면으로 이동(로그인)
            },
          ),
        ],
      ),
    );
  }
}

class Shoeslistpage extends StatefulWidget {
  const Shoeslistpage({super.key});

  @override
  State<Shoeslistpage> createState() => _ShoeslistpageState();
}

class _ShoeslistpageState extends State<Shoeslistpage> {
  late DatabaseHandler handler; // 데이터베이스 핸들러
  late List<Product> _products; // 전체 상품 목록
  late List<Product> _filteredProducts; // 검색 필터링된 상품 목록
  late String _searchText; // 검색어 텍스트
  Map<String, int> selectedSizes = {}; // 제품별 선택된 사이즈 저장

  @override // 변수 초기화
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    _products = [];
    _filteredProducts = [];
    _searchText = '';
  }

  // 상품 카드 위젯 생성
  Widget _buildProductCard(Product product) {
    // 10단위 사이즈 리스트
    final List<int> sizeOptions = List.generate(8, (index) => 220 + (index * 10));
    // product.psize가 10단위가 아니면 가장 가까운 10단위로 보정
    int defaultSize = ((product.psize / 10).round() * 10).clamp(220, 290);
    int selectedSize = selectedSizes[product.pid] ?? defaultSize;
    // 만약 selectedSize가 옵션에 없다면, 가장 가까운 값으로 대체
    if (!sizeOptions.contains(selectedSize)) {
      selectedSize = defaultSize;
    }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black, width: 2),
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => ShoesDetailPage(
            product: product,
            selectedSize: selectedSize,
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지 영역을 더 크게 (flex: 7)
              Expanded(
                flex: 7,
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
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '신발\n이미지',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 8),
              // 상품명, 가격, 색상
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.pname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${product.pprice}원',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '색상: ${product.pcolor}',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 2),
                    // 드롭다운 최소화
                    Row(
                      children: [
                        Text('사이즈:', style: TextStyle(fontSize: 11)),
                        SizedBox(width: 2),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.7),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: DropdownButton<int>(
                            value: selectedSize,
                            isDense: true,
                            iconSize: 16,
                            style: TextStyle(fontSize: 11, color: Colors.black),
                            underline: SizedBox(),
                            dropdownColor: Colors.white,
                            items: sizeOptions
                                .map((size) => DropdownMenuItem(
                                      value: size,
                                      child: Text('$size'),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedSizes[product.pid] = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 드로우바 다른데서도 사용가능한 위젯으로 만듬 drawer: MainDrawer()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('상품 구매 화면'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.receipt_long),
            tooltip: '주문내역',
            onPressed: () {
              Get.to(() => OrderViewPage());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '제품명 검색',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.purple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                _searchText = query;
                _filteredProducts =
                    _products
                        .where((p) => p.pname.contains(_searchText))
                        .toList();
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: handler.getAllproducts(),
              builder: (context, snapshot) {
                // 연결 중 상태이면 뱅글뱅글 돔
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                //스냅샷데이터 없거나 비어있으면 화면에 상품 없음 텍스트 등장
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('상품이 없습니다.'));
                }
                // 최초 데이터 세팅, 검색창 비어있음 모든 목록 검색어 있음 해당 검색어 있는 목록
                if (_products.isEmpty) {
                  _products = snapshot.data!;
                  _filteredProducts =
                      _searchText.isEmpty
                          ? _products
                          : _products
                              .where((p) => p.pname.contains(_searchText))
                              .toList();
                }
                // 상품 이미지 그리드뷰
                return GridView.builder(
                  padding: EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.68, // 이미지가 더 크게
                  ),
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(_filteredProducts[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// 더미 //
