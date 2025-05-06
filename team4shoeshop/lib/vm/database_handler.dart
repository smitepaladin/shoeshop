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


//employee에 28개 데이터 넣기.
// 대리점 id d001 ~ d025, 본사 id h001 ~ h003, 비번 모두 1234
Future<void> insertDefaultEmployeesIfEmpty() async {
  final db = await initializeDB();
  final existing = await db.query('employee');

  if (existing.isEmpty) {
    // 25개 대리점: 자치구청 위도/경도 사용
    await db.insert('employee', {
      'eid': 'd001', 'ename': '강남구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5172, 'elongdata': 127.0473
    });
    await db.insert('employee', {
      'eid': 'd002', 'ename': '강동구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5302, 'elongdata': 127.1238
    });
    await db.insert('employee', {
      'eid': 'd003', 'ename': '강북구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.6396, 'elongdata': 127.0256
    });
    await db.insert('employee', {
      'eid': 'd004', 'ename': '강서구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5509, 'elongdata': 126.8495
    });
    await db.insert('employee', {
      'eid': 'd005', 'ename': '관악구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.4784, 'elongdata': 126.9516
    });
    await db.insert('employee', {
      'eid': 'd006', 'ename': '광진구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5384, 'elongdata': 127.0823
    });
    await db.insert('employee', {
      'eid': 'd007', 'ename': '구로구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.4954, 'elongdata': 126.8874
    });
    await db.insert('employee', {
      'eid': 'd008', 'ename': '금천구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.4568, 'elongdata': 126.8950
    });
    await db.insert('employee', {
      'eid': 'd009', 'ename': '노원구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.6542, 'elongdata': 127.0568
    });
    await db.insert('employee', {
      'eid': 'd010', 'ename': '도봉구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.6688, 'elongdata': 127.0472
    });
    await db.insert('employee', {
      'eid': 'd011', 'ename': '동대문구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5744, 'elongdata': 127.0396
    });
    await db.insert('employee', {
      'eid': 'd012', 'ename': '동작구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5124, 'elongdata': 126.9392
    });
    await db.insert('employee', {
      'eid': 'd013', 'ename': '마포구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5663, 'elongdata': 126.9014
    });
    await db.insert('employee', {
      'eid': 'd014', 'ename': '서대문구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5791, 'elongdata': 126.9368
    });
    await db.insert('employee', {
      'eid': 'd015', 'ename': '서초구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.4836, 'elongdata': 127.0327
    });
    await db.insert('employee', {
      'eid': 'd016', 'ename': '성동구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5633, 'elongdata': 127.0364
    });
    await db.insert('employee', {
      'eid': 'd017', 'ename': '성북구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5894, 'elongdata': 127.0167
    });
    await db.insert('employee', {
      'eid': 'd018', 'ename': '송파구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5145, 'elongdata': 127.1059
    });
    await db.insert('employee', {
      'eid': 'd019', 'ename': '양천구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5169, 'elongdata': 126.8666
    });
    await db.insert('employee', {
      'eid': 'd020', 'ename': '영등포구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5263, 'elongdata': 126.8962
    });
    await db.insert('employee', {
      'eid': 'd021', 'ename': '용산구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5323, 'elongdata': 126.9909
    });
    await db.insert('employee', {
      'eid': 'd022', 'ename': '은평구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.6027, 'elongdata': 126.9291
    });
    await db.insert('employee', {
      'eid': 'd023', 'ename': '종로구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5729, 'elongdata': 126.9794
    });
    await db.insert('employee', {
      'eid': 'd024', 'ename': '중구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5636, 'elongdata': 126.9972
    });
    await db.insert('employee', {
      'eid': 'd025', 'ename': '중랑구', 'epassword': '1234', 'epermission': 0,
      'elatdate': 37.5985, 'elongdata': 127.0928
    });

    // 본사 직원 3명 (사원, 팀장, 임원)
    await db.insert('employee', {
      'eid': 'h001', 'ename': '본사사원', 'epassword': '1234', 'epermission': 1,
      'elatdate': null, 'elongdata': null
    });
    await db.insert('employee', {
      'eid': 'h002', 'ename': '본사팀장', 'epassword': '1234', 'epermission': 2,
      'elatdate': null, 'elongdata': null
    });
    await db.insert('employee', {
      'eid': 'h003', 'ename': '본사임원', 'epassword': '1234', 'epermission': 3,
      'elatdate': null, 'elongdata': null
    });
  }
}

// factory에 2개 데이터 넣기
Future<void> insertDefaultFactoriesIfEmpty() async {
  final db = await initializeDB();
  final existing = await db.query('factory');

  if (existing.isEmpty) {
    await db.insert('factory', {
      'fid': 'F001',
      'fbrand': 'Nike',
      'fphone': '02-1234-5678',
    });

    await db.insert('factory', {
      'fid': 'F002',
      'fbrand': 'Adidas', 
      'fphone': '02-8765-4321',
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
