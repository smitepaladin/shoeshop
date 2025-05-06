import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:team4shoeshop/model/customer.dart';
import 'package:team4shoeshop/model/orders.dart';
import 'package:team4shoeshop/model/product.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'shoeshop.db'),
      onCreate: (db, version) async {
        // approval 테이블
        await db.execute(
          "create table approval(aid integer primary key autoincrement, aeid text, afid text, abaljoo integer, asoojoo integer, astatus text, adate text, ateamappdate text, achiefappdate text)",
        );

        // customer 테이블
        await db.execute(
          "create table customer(id integer primary key autoincrement, cid text, cname text, cpassword text, cphone text, cemail text, caddress text, ccardnum integer, ccardcvc integer, ccarddate integer)",
        );

        // employee 테이블
        await db.execute(
          "create table employee(eid text primary key, ename text, epassword text, epermission integer, elatdate real, elongdata real)",
        );

        // factory 테이블
        await db.execute(
          "create table factory(fid text primary key, fbrand text, fphone text)",
        );

        // ✅ orders 테이블 (order → orders)
        await db.execute(
          "create table orders(oid integer primary key autoincrement, ocid text, opid text, oeid text, ocount integer, odate text, ostatus text, ocartbool integer, oreturncount integer, oreturndate text, oreturnstatus text, odefectivereason text, oreason text)",
        );

        // product 테이블
        await db.execute(
          "create table product(id integer primary key autoincrement, pid text, pbrand text, pname text, psize integer, pcolor text, pstock integer, pprice integer, pimage blob)",
        );
      },
      version: 1,
    );
  }

  // 로그인 시 나오는 첫 화면: 상품 전체 조회
  Future<List<Product>> getAllproducts() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
      'select * from product order by pname',
    );
    return queryResult.map((e) => Product.fromMap(e)).toList();
  }

  // Product에 임시 데이터 2개 넣기
  Future<void> insertDefaultProductsIfEmpty() async {
  final db = await initializeDB();
  final existing = await db.query('product');

  if (existing.isEmpty) {
    Uint8List emptyImage = Uint8List(0); // 빈 이미지

    await db.insert('product', {
      'pid': 'SH001',
      'pbrand': 'Nike',
      'pname': 'Air Max 90',
      'psize': 270,
      'pcolor': 'Black',
      'pstock': 100,
      'pprice': 129000,
      'pimage': emptyImage,
    });

    await db.insert('product', {
      'pid': 'SH002',
      'pbrand': 'Adidas',
      'pname': 'Ultra Boost',
      'psize': 275,
      'pcolor': 'White',
      'pstock': 100,
      'pprice': 159000,
      'pimage': emptyImage,
    });
  }
}

  // 결제 내역 페이지 (orders 테이블 조회)
  Future<List<Orders>> getAllorders() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
      'select * from orders order by odate',
    );
    return queryResult.map((e) => Orders.fromMap(e)).toList();
  }

  // 주문된 상품 ID로 상품 정보 조회
  Future<Product?> getProductByPid(String pid) async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
      'select * from product where pid=?',
      [pid],
    );
    if (queryResult.isNotEmpty) {
      return Product.fromMap(queryResult.first);
    }
    return null;
  }

  // 회원가입 정보 insert
  Future<int> insertJoin(Customer customer) async {
    final Database db = await initializeDB();
    return await db.insert('customer', {
      'cid': customer.cid,
      'cname': customer.cname,
      'cpassword': customer.cpassword,
      'cphone': customer.cphone,
      'cemail': customer.cemail,
      'caddress': customer.caddress,
      'ccardnum': customer.ccardnum,
      'ccardcvc': customer.ccardcvc,
      'ccarddate': customer.ccarddate,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 로그인 확인용 메서드 추가
  Future<bool> checkLogin(String cid, String password) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM customer WHERE cid = ? AND cpassword = ?',
      [cid, password],
    );
    return result.isNotEmpty;
  }
}
