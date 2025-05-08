import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:team4shoeshop/view/login.dart';
import 'package:team4shoeshop/vm/database_handler.dart'; // ← DB 핸들러 경로 확인

void main() async {
  // Flutter에서 async 초기화할 때 필수
  WidgetsFlutterBinding.ensureInitialized();

  // DB 초기화 및 기본 상품 샘플 등록
  final handler = DatabaseHandler();
  await handler.initializeDB();
  await GetStorage.init(); 
  await handler.insertDefaultProductsIfEmpty(); // 샘플 상품 자동 삽입
  await handler.insertDefaultEmployeesIfEmpty(); // 샘플 emplyee 데이터 삽입.
  await handler.insertDefaultFactoriesIfEmpty(); // 샘플 factory 데이터 삽입.
  // await handler.insertDefaultOrdersIfEmpty();
  // await handler.insertDefaultApprovalsIfEmpty();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '신발 주문 앱',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Login(), // 앱 시작 시 로그인 화면
    );
  }
}
