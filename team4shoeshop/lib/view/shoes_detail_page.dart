import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/model/product.dart';
import 'package:team4shoeshop/model/employee.dart';
import 'package:team4shoeshop/model/customer.dart';
import 'package:team4shoeshop/vm/database_handler.dart';
import 'buy.dart';
import 'cart.dart';
import 'edit_profile_page.dart';

class ShoesDetailPage extends StatefulWidget {
  final Product product;
  final int selectedSize;

  const ShoesDetailPage({
    required this.product,
    required this.selectedSize,
    super.key,
  });

  @override
  State<ShoesDetailPage> createState() => _ShoesDetailPageState();
}

class _ShoesDetailPageState extends State<ShoesDetailPage> {
  final DatabaseHandler handler = DatabaseHandler();
  final box = GetStorage();
  List<Employee> stores = [];
  String? selectedStoreId;
  int selectedQuantity = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    final db = await handler.initializeDB();
    final result = await db.query(
      'employee',
      where: 'epermission = ?',
      whereArgs: [0],
    );
    setState(() {
      stores = result.map((e) => Employee.fromMap(e)).toList();
      if (stores.isNotEmpty) selectedStoreId = stores.first.eid;
      isLoading = false;
    });
  }

  Future<void> _addToCart() async {
    if (widget.product.pstock == 0) {
      Get.snackbar('재고 없음', '해당 상품은 품절입니다.', 
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      return;
    }

    if (selectedStoreId == null) {
      Get.snackbar('알림', '대리점을 선택해주세요.', 
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      return;
    }

    final cid = box.read('p_userId');
    if (cid == null) {
      Get.snackbar('알림', '로그인이 필요합니다.', 
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      return;
    }

    final db = await handler.initializeDB();
    await db.insert('orders', {
      'ocid': cid,
      'opid': widget.product.pid,
      'oeid': selectedStoreId,
      'ocount': selectedQuantity,
      'odate': DateTime.now().toString().substring(0,10),
      'ostatus': '장바구니',
      'ocartbool': 1,
      'oreturncount': 0,
      'oreturndate': '',
      'oreturnstatus': '',
      'odefectivereason': '',
      'oreason': '',
    });

    Get.snackbar('성공', '장바구니에 추가되었습니다.', 
      duration: Duration(seconds: 2),
      backgroundColor: Colors.blue);
  }

  Future<void> _checkAndBuy() async {
    if (widget.product.pstock == 0) {
      Get.snackbar('재고 없음', '해당 상품은 품절입니다.', 
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      return;
    }

    if (selectedStoreId == null) {
      Get.snackbar('알림', '대리점을 선택해주세요.', 
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      return;
    }

    final cid = box.read('p_userId') ?? '';
    final db = await handler.initializeDB();
    final result = await db.query('customer', where: 'cid = ?', whereArgs: [cid]);

    if (result.isEmpty) {
      Get.snackbar('오류', '회원 정보를 찾을 수 없습니다.',
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      return;
    }

    final customer = Customer.fromMap(result.first);
    if (customer.ccardnum == 0 || customer.ccardcvc == 0 || customer.ccarddate == 0) {
      Get.snackbar('카드 정보 없음', '회원정보를 먼저 수정해주세요.', 
        duration: Duration(seconds: 2),
        backgroundColor: Colors.blue);
      await Future.delayed(Duration(seconds: 1));
      Get.to(() => const EditProfilePage());
      return;
    }

    Get.to(() => BuyPage(), arguments: {
      'product': widget.product,
      'quantity': selectedQuantity,
      'storeId': selectedStoreId,
      'selectedSize': widget.selectedSize,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(24.0),
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
                            child: Center(child: Text('신발\n이미지')),
                          ),
                  ),
                  SizedBox(height: 24),
                  _buildInfoRow('상품명', widget.product.pname),
                  _buildInfoRow('브랜드', widget.product.pbrand),
                  _buildInfoRow('색깔', widget.product.pcolor),
                  _buildInfoRow('SIZE', '${widget.product.psize}'),
                  _buildDropdownRow('수량', selectedQuantity, widget.product.pstock, (value) {
                  selectedQuantity = value;
                    setState(() { });
                  }),
                  _buildStoreDropdown(),
                  _buildInfoRow('가격', '${widget.product.pprice}원'),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('장바구니'),
                      ),
                      ElevatedButton(
                        onPressed: _checkAndBuy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("구매하기"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  Widget _buildDropdownRow(String label, int selected, int max, ValueChanged<int> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<int>(
          value: selected,
          items: List.generate(max, (i) => i + 1)
              .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }

  Widget _buildStoreDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('대리점', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: selectedStoreId,
          items: stores.map((store) {
            return DropdownMenuItem(
              value: store.eid,
              child: Text(store.ename),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedStoreId = value;
              });
            }
          },
        ),
      ],
    );
  }
}
