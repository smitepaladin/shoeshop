/*
2025.05.05 이학현 / admin/widget 폴더, admin drawer 위젯 생성
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/admin/admin_approval.dart';
import 'package:team4shoeshop/view/admin/admin_daily_revenue.dart';
import 'package:team4shoeshop/view/admin/admin_dealer_revenue.dart';
import 'package:team4shoeshop/view/admin/admin_goods_revenue.dart';
import 'package:team4shoeshop/view/admin/admin_inven.dart';
import 'package:team4shoeshop/view/admin/admin_main.dart';
import 'package:team4shoeshop/view/admin/admin_return.dart';
import 'package:team4shoeshop/view/admin/admin_sales.dart';
import 'package:team4shoeshop/view/admin/admin_product_insert.dart';
import 'package:team4shoeshop/view/adminlogin.dart';

class AdminDrawer extends StatelessWidget {
  final box = GetStorage();
  AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(box.read('adminName') ?? '로그인 필요'),
            accountEmail: Text(box.read('adminId') ?? ''),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('메인 화면'),
            onTap: () {
              Get.off(AdminMain());
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('전체 재고 현황'),
            onTap: () {
              Get.off(AdminInven());
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('판매 현황 통계'),
            onTap: () {
              Get.off(AdminSales());
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('기안 및 결재'),
            onTap: () {
              Get.off(AdminApproval());
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('반품 내역'),
            onTap: () {
              Get.off(AdminReturn());
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('일자별 매출 현황'),
            onTap: () {
              Get.to(AdminDailyRevenue());
            },
          ),
          ListTile(
            leading: const Icon(Icons.store),
            title: const Text('지점별 매출 현황'),
            onTap: () {
              Get.to(AdminDealerRevenue());
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_basket),
            title: const Text('상품별 매출 현황'),
            onTap: () {
              Get.to(AdminGoodsRevenue());
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box),
            title: const Text('상품 등록'), // ✅ 추가 메뉴
            onTap: () {
              Get.to(const AdminProductInsert());
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('로그아웃'),
            onTap: () {
              box.erase();
              Get.offAll(Adminlogin());
            },
          ),
        ],
      ),
    );
  }
}
