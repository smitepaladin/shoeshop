import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/adminlogin.dart';
import 'package:team4shoeshop/view/dealer/dealer_main.dart';
import 'package:team4shoeshop/view/dealer/dealer_return.dart';

class DealerDrawer extends StatelessWidget {
  final box = GetStorage();
  DealerDrawer({super.key});

 @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(box.read('adminName') ?? '로그인 필요'),
            accountEmail: Text(box.read('adminId') ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('지점 매출 현황'),
            onTap: () {
              Get.off(DealerMain());
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('반품 현황'),
            onTap: () {
              Get.off(DealerReturn());
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