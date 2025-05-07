/*
2025.05.05 이학현 / admin/widget 폴더, admin drawer 위젯 생성
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/admin/widget/receive.dart';
import 'package:team4shoeshop/view/adminlogin.dart';

// 다른 페이지에서도 사용용 가능한 Drawer 위젯
class AdminDrawer extends StatelessWidget {
  final box = GetStorage();
  AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    String adminId = box.read('adminId') ?? '';
    return Drawer(
      child: ListView(
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
            title: Text('전체 재고 현황'),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('판매 현황 통계'),
            onTap: () {
              //
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long),
            title: Text('기안 및 결재'),
            onTap: () {
              //
            },
          ),
          ListTile(
            leading: Icon(Icons.verified),
            title: Text('결제 확인'),
            onTap: () {
              //
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('반품 내역'),
            onTap: () {
              //
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('일자별 매출 현황'),
            onTap: () {
              //
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_return),
            title: Text('지점별 매출 현황'),
            onTap: () {
              //
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_return),
            title: Text('상품별 매출 현황'),
            onTap: () {
              //
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