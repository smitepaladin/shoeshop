import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/view/admin/admim_salastoday.dart';

import 'package:team4shoeshop/view/adminlogin.dart';

import 'oreturn.dart';
import 'receive.dart';
import 'salestoday.dart';

class SalesmonthPage extends StatefulWidget {
  const SalesmonthPage({super.key});

  @override
  State<SalesmonthPage> createState() => _SalesmonthPageState();
}

class _SalesmonthPageState extends State<SalesmonthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('slaemonth페이지'),
      ),
      drawer: Drawer(
child: ListView(
children: [
DrawerHeader(child: Text('cba 신발 상점')),
ListTile(
title: Text('상품 수령 목록'),
onTap: () => Get.to(() => ReceivePage()),
),
ListTile(
title: Text('반품 처리 현황'),
onTap: () => Get.to(() => OreturnPage()),
),
ListTile(
title: Text('일별 매출목록'),
onTap: () => Get.to(() => SalastodayPage()),
),
ListTile(
title: Text('월별매출목록'),
onTap: () => Get.to(() => SalestodayPage()),
),
ListTile(
title: Text('관리자 로그인페이지'),
onTap: () => Get.to(() => Adminlogin()),
),
],
),
),
);
}
}