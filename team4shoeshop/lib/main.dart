import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team4shoeshop/view/login.dart';
import 'package:team4shoeshop/vm/database_handler.dart'; // ← 꼭 import 추가!

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 비동기 초기화
  final handler = DatabaseHandler();
  await handler.insertDefaultProductsIfEmpty(); // 샘플 상품 자동 삽입
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Login(), // 시작화면은 로그인
    );
  }
}
