import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/view/admin/oreturn.dart';

import 'receive.dart';
import 'salesmonth.dart';

class SalestodayPage extends StatefulWidget {
  const SalestodayPage({super.key});

  @override
  State<SalestodayPage> createState() => _SalestodayPageState();
}

class _SalestodayPageState extends State<SalestodayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('salestoday'),

      ),drawer: Drawer(
child: ListView(
children: [
DrawerHeader(child: Text('cba 신발 상점')),
ListTile(
title: Text('상품 수령 목록'),
onTap: () => Get.to(() => ReceivePage()),
),
ListTile(
title: Text('지점 일매출 현황'),
onTap: () => Get.to(() => SalestodayPage()),
),
ListTile(
title: Text('지점 월매출 현황'),
onTap: () => Get.to(() => SalesmonthPage()),
),
ListTile(
title: Text('반품 처리 현황'),
onTap: () => Get.to(() => OreturnPage()),
),
],
),
),

);
}
}
