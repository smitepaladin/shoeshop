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

class MainDrawer extends StatelessWidget {
  final box = GetStorage();
  MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = box.read('p_userId') ?? '';

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userId.isNotEmpty ? userId : '로그인 필요',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: null,
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.deepPurple),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildTile(context, Icons.shopping_bag, '상품 구매', () {
                  Get.back();
                }),
                _buildTile(context, Icons.person_outline, '회원정보 수정', () {
                  Get.to(() => EditProfilePage());
                }),
                _buildTile(context, Icons.receipt_long, '내 주문 내역', () {
                  Get.to(() => OrderViewPage());
                }),
                _buildTile(context, Icons.shopping_cart, '장바구니', () {
                  Get.to(() => CartPage());
                }),
                _buildTile(context, Icons.location_on, '위치 검색', () {
                  Get.to(() => LocationSearch());
                }),
                _buildTile(context, Icons.assignment_return, '반품 내역 확인', () {
                  Get.to(() => Returns());
                }),
                const Divider(height: 30),
                _buildTile(context, Icons.logout, '로그아웃', () {
                  box.erase();
                  Get.offAllNamed('/');
                }, iconColor: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap,
      {Color? iconColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      onTap: onTap,
      horizontalTitleGap: 8.0,
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      hoverColor: Colors.grey[200],
    );
  }
}


class Shoeslistpage extends StatefulWidget {
  const Shoeslistpage({super.key});

  @override
  State<Shoeslistpage> createState() => _ShoeslistpageState();
}

class _ShoeslistpageState extends State<Shoeslistpage> {
  late DatabaseHandler handler;
  late List<Product> _products;
  late List<Product> _filteredProducts;
  late String _searchText;
  Map<String, int> selectedSizes = {};

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    _products = [];
    _filteredProducts = [];
    _searchText = '';
  }

  List<int> getSizeOptions() => List.generate(5, (index) => 230 + index * 10);

  Widget _buildProductCard(Product product) {
    final List<int> sizeOptions = getSizeOptions();
    int defaultSize = ((product.psize / 10).round() * 10).clamp(230, 270);
    int selectedSize = selectedSizes[product.pid] ?? defaultSize;
    if (!sizeOptions.contains(selectedSize)) selectedSize = defaultSize;

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
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            '신발\n사진',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 8),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.pname,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text('${product.pprice}원',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    Text('색상: ${product.pcolor}', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 2),
                    Text('사이즈: ${product.psize}', style: TextStyle(fontSize: 12),)
                    // Row(
                    //   children: [
                    //     const Text('사이즈:', style: TextStyle(fontSize: 11)),
                    //     const SizedBox(width: 2),
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(horizontal: 2),
                    //       decoration: BoxDecoration(
                    //         border: Border.all(color: Colors.grey, width: 0.7),
                    //         borderRadius: BorderRadius.circular(3),
                    //       ),
                    //       child: DropdownButton<int>(
                    //         value: selectedSize,
                    //         isDense: true,
                    //         iconSize: 16,
                    //         style: const TextStyle(fontSize: 11, color: Colors.black),
                    //         underline: const SizedBox(),
                    //         dropdownColor: Colors.white,
                    //         items: sizeOptions
                    //             .map((size) =>
                    //                 DropdownMenuItem(value: size, child: Text('$size')))
                    //             .toList(),
                    //         onChanged: (value) {
                    //           if (value != null) {
                    //             setState(() {
                    //               selectedSizes[product.pid] = value;
                    //             });
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('상품 구매 화면'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: '주문내역',
            onPressed: () => Get.to(() => OrderViewPage()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: '제품명 검색',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.purple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                _searchText = query;
                _filteredProducts = _products
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('상품이 없습니다.'));
                }
                if (_products.isEmpty) {
                  _products = snapshot.data!;
                  _filteredProducts = _searchText.isEmpty
                      ? _products
                      : _products.where((p) => p.pname.contains(_searchText)).toList();
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.68,
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
