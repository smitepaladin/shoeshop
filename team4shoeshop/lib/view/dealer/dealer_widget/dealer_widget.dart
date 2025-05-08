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
import 'package:team4shoeshop/view/adminlogin.dart';

class AdminDrawer extends StatelessWidget {
  final box = GetStorage();
  AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String adminId = box.read('adminId') ?? '';
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(adminId.isNotEmpty ? adminId : '로그인 필요'),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('메인 화면'),
            onTap: () {
              Get.off(AdminMain());
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('전체 재고 현황'),
            onTap: () {
              Get.off(AdminInven());
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('판매 현황 통계'),
            onTap: () {
              Get.off(AdminSales());
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('기안 및 결재'),
            onTap: () {
              Get.off(AdminApproval());
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('반품 내역'),
            onTap: () {
              Get.off(AdminReturn());
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('일자별 매출 현황'),
            onTap: () {
              Get.to(AdminDailyRevenue());
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_return),
            title: Text('지점별 매출 현황'),
            onTap: () {
              Get.to(AdminDealerRevenue());
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_return),
            title: Text('상품별 매출 현황'),
            onTap: () {
              Get.to(AdminGoodsRevenue());
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('로그아웃'),
            onTap: () {
              box.erase();
              Get.offAll(Adminlogin()); // 첫 화면으로 이동(로그인)
            },
          ),
        ],
      ),
    );
  }
}