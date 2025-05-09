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
          "create table approval(aid integer primary key autoincrement, aeid text, afid text, apid text, abaljoo integer, asoojoo integer, astatus text, adate text, ateamappdate text, achiefappdate text)",
        );
        // approval 초기데이터 상태 : 대기, 팀장승인, 임원승인
        // await db.insert('approval', {
        //   'aeid': 'h001',
        //   'afid': 'fac001', 
        //   'apid': 'prd001', 
        //   'abaljoo': 100, 
        //   'asoojoo': 0, 
        //   'astatus': '팀장승인', 
        //   'adate': '2025-05-07', 
        //   'ateamappdate': '2025-05-07', 
        //   'achiefappdate': null, 
        // });

        // await db.insert('approval', {
        //   'aeid': 'h001',
        //   'afid': 'fac002', 
        //   'apid': 'prd002', 
        //   'abaljoo': 110, 
        //   'asoojoo': 0, 
        //   'astatus': '대기', 
        //   'adate': '2025-05-06', 
        //   'ateamappdate': null, 
        //   'achiefappdate': null, 
        // });

        // await db.insert('approval', {
        //   'aeid': 'h001',
        //   'afid': 'fac001', 
        //   'apid': 'prd001', 
        //   'abaljoo': 120, 
        //   'asoojoo': 0, 
        //   'astatus': '임원승인', 
        //   'adate': '2025-05-07', 
        //   'ateamappdate': '2025-05-07', 
        //   'achiefappdate': '2025-05-08', 
        // });

        // await db.insert('approval', {
        //   'aeid': 'h001',
        //   'afid': 'fac002', 
        //   'apid': 'prd002', 
        //   'abaljoo': 130, 
        //   'asoojoo': 0, 
        //   'astatus': '대기', 
        //   'adate': '2025-05-08', 
        //   'ateamappdate': null, 
        //   'achiefappdate': null, 
        // });

        // await db.insert('approval', {
        //   'aeid': 'h001',
        //   'afid': 'fac001', 
        //   'apid': 'prd001', 
        //   'abaljoo': 140, 
        //   'asoojoo': 0, 
        //   'astatus': '대기', 
        //   'adate': '2025-05-09', 
        //   'ateamappdate': null, 
        //   'achiefappdate': null, 
        // });

        // customer 테이블
        await db.execute(
          "create table customer(id integer primary key autoincrement, cid text, cname text, cpassword text, cphone text, cemail text, caddress text, ccardnum integer, ccardcvc integer, ccarddate integer)",
        );

        // customer 초기 데이터
        // await db.insert('customer', {
        //   'cid': 'cust001',
        //   'cname': '홍길동',
        //   'cpassword': '1234',
        //   'cphone': '01012345678',
        //   'cemail': 'hong@example.com',
        //   'caddress': '서울시 강남구',
        //   'ccardnum': 1234567890123456,
        //   'ccardcvc': 123,
        //   'ccarddate': 2506,
        // });

        // employee 테이블
        // final String eid; // 직원 ID
        // final String ename; // 직원 이름
        // final String epassword; // 직원 비밀번호
        // final int epermission; // 직원 직위(0대리점주, 1사원, 2팀장, 3임원)
        // final double elatdata; // 대리점 위도
        // final double elongdata; // 대리점 경도

        // employee 테이블
        await db.execute(
          "create table employee(eid text primary key, ename text, epassword text, epermission integer, elatdata real, elongdata real)",
        );

        // factory 테이블
        await db.execute(
          "create table factory(fid text primary key, fbrand text, fphone text)",
        );

        // factory 초기 데이터
        await db.insert('factory', {
          'fid': 'fac001',
          'fbrand': '나이키',
          'fphone': '02-1111-0001',
        });

        await db.insert('factory', {
          'fid': 'fac002',
          'fbrand': '아디다스',
          'fphone': '02-1111-0002',
        });

        await db.insert('factory', {
          'fid': 'fac003',
          'fbrand': '뉴발란스',
          'fphone': '02-1111-0003',
        });

        await db.insert('factory', {
          'fid': 'fac004',
          'fbrand': '컨버스',
          'fphone': '02-1111-0004',
        });

        await db.insert('factory', {
          'fid': 'fac005',
          'fbrand': '리복',
          'fphone': '02-1111-0005',
        });

        // order 테이블
        // final int? oid; // 주분번호 autoincrement
        // final String ocid; // 고객 ID
        // final String opid; // 신발 ID
        // final String oeid; // 직원 ID
        // final int ocount; // 주문수량
        // final String odate; // 주문일자
        // final String ostatus; // 상품 상태(발송 도착 수령)
        // final bool ocartbool; // 장바구니 여부
        // final int oreturncount; // 반품수량
        // final String oreturndate; // 반품일
        // final String oreturnstatus; // 반품 상태(반품,제조사 발송)
        // final String odefectivereason; // 제조사 규명 하자 내용
        // final String oreason; // 반품 이유

        // orders 테이블 (order → orders)
        await db.execute(
          "create table orders(oid integer primary key autoincrement, ocid text, opid text, oeid text, ocount integer, odate text, ostatus text, ocartbool integer, oreturncount integer, oreturndate text, oreturnstatus text, odefectivereason text, oreason text)",
        );

        // // order 초기 데이터
        // // 전월 주문 - 4월
        // await db.insert('orders', {
        //   'ocid': 'cust001',
        //   'opid': 'prd001', // 에어맥스
        //   'oeid': 'd001',
        //   'ocount': 2,
        //   'odate': '2025-04-10',
        //   'ostatus': '결제완료',
        //   'ocartbool': 0,
        //   'oreturncount': 0,
        //   'oreturndate': '',
        //   'oreturnstatus': '',
        //   'odefectivereason': '',
        //   'oreason': '',
        // });

        // await db.insert('orders', {
        //   'ocid': 'cust001',
        //   'opid': 'prd002', // 울트라부스트
        //   'oeid': 'd002',
        //   'ocount': 1,
        //   'odate': '2025-04-25',
        //   'ostatus': '결제완료',
        //   'ocartbool': 0,
        //   'oreturncount': 0,
        //   'oreturndate': '',
        //   'oreturnstatus': '',
        //   'odefectivereason': '',
        //   'oreason': '',
        // });

        // // 당월 주문 - 5월
        // await db.insert('orders', {
        //   'ocid': 'cust001',
        //   'opid': 'prd001', // 990v5
        //   'oeid': 'd001',
        //   'ocount': 3,
        //   'odate': '2025-04-10',
        //   'ostatus': '결제완료',
        //   'ocartbool': 0,
        //   'oreturncount': 0,
        //   'oreturndate': '',
        //   'oreturnstatus': '',
        //   'odefectivereason': '',
        //   'oreason': '',
        // });

        // await db.insert('orders', {
        //   'ocid': 'cust001',
        //   'opid': 'prd002', // 척테일러
        //   'oeid': 'h003', // 본사임원
        //   'ocount': 1,
        //   'odate': '2025-05-07',
        //   'ostatus': '결제완료',
        //   'ocartbool': 0,
        //   'oreturncount': 0,
        //   'oreturndate': '',
        //   'oreturnstatus': '',
        //   'odefectivereason': '',
        //   'oreason': '',
        // });

        // // 반품 초기데이터
        // await db.insert('orders', {
        //   'ocid': 'cust001',
        //   'opid': 'prd002', // 예: 나이키 에어맥스
        //   'oeid': 'h002',
        //   'ocount': 1,
        //   'odate': '2025-05-01',
        //   'ostatus': '반품완료',
        //   'ocartbool': 0,
        //   'oreturncount': 1,
        //   'oreturndate': '2025-05-04',
        //   'oreturnstatus': '완료',
        //   'odefectivereason': '사이즈 불량',
        //   'oreason': '사이즈가 맞지 않음',
        // });

        // await db.insert('orders', {
        //   'ocid': 'cust001',
        //   'opid': 'prd001', // 예: 아디다스 슈퍼스타
        //   'oeid': 'h001',
        //   'ocount': 2,
        //   'odate': '2025-04-28',
        //   'ostatus': '반품요청',
        //   'ocartbool': 0,
        //   'oreturncount': 2,
        //   'oreturndate': '2025-05-05',
        //   'oreturnstatus': '요청',
        //   'odefectivereason': '불량',
        //   'oreason': '제품에 하자가 있음',
        // });

        // await db.insert('orders', {
        //   'ocid': 'cust001',
        //   'opid': 'prd001', // 예: 반스 올드스쿨
        //   'oeid': 'h002',
        //   'ocount': 1,
        //   'odate': '2025-05-03',
        //   'ostatus': '반품처리중',
        //   'ocartbool': 0,
        //   'oreturncount': 1,
        //   'oreturndate': '2025-05-06',
        //   'oreturnstatus': '처리중',
        //   'odefectivereason': '변심',
        //   'oreason': '디자인이 마음에 들지 않음',
        // });

        // product 테이블
        // final int? id; // 신발 테이블 기본 id autoincrement
        // final String pid; // 신발 ID
        // final String pbrand; // 제품 브랜드
        // final String pname; // 제품 이름
        // final int psize; // 사이즈
        // final String pcolor; // 색상
        // final int pstock; // 재고
        // final int pprice; // 가격
        // final Uint8List pimage; // 이미지

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

Future<void> insertDefaultProductsIfEmpty() async {
  final db = await initializeDB();

  final existing = await db.query('product'); // 존재 여부 확인
  if (existing.isNotEmpty) {
    // print('>>> Product 테이블이 이미 존재합니다. 초기 데이터 삽입 생략.');
    return; // 아무것도 하지 않음
  }

  // Uint8List emptyImage = Uint8List(0);

  // //이제 테이블이 비었을 경우에만 insert 수행
  // await db.insert('product', {
  //   'pid': 'prd001',
  //   'pbrand': '나이키',
  //   'pname': '에어맥스',
  //   'psize': 270,
  //   'pcolor': '검정',
  //   'pstock': 50,
  //   'pprice': 129000,
  //   'pimage': emptyImage,
  // });

  // await db.insert('product', {
  //   'pid': 'prd002',
  //   'pbrand': '아디다스',
  //   'pname': '울트라부스트',
  //   'psize': 265,
  //   'pcolor': '흰색',
  //   'pstock': 29,
  //   'pprice': 139000,
  //   'pimage': emptyImage,
  // });

  // await db.insert('product', {
  //   'pid': 'prd001',
  //   'pbrand': '뉴발란스',
  //   'pname': '990v5',
  //   'psize': 280,
  //   'pcolor': '회색',
  //   'pstock': 40,
  //   'pprice': 159000,
  //   'pimage': emptyImage,
  // });

  // await db.insert('product', {
  //   'pid': 'prd002',
  //   'pbrand': '컨버스',
  //   'pname': '척테일러',
  //   'psize': 260,
  //   'pcolor': '빨강',
  //   'pstock': 60,
  //   'pprice': 69000,
  //   'pimage': emptyImage,
  // });

  // await db.insert('product', {
  //   'pid': 'prd001',
  //   'pbrand': '리복',
  //   'pname': '클래식레더',
  //   'psize': 275,
  //   'pcolor': '네이비',
  //   'pstock': 35,
  //   'pprice': 99000,
  //   'pimage': emptyImage,
  // });

  }

  

  //employee에 28개 데이터 넣기.
  // 대리점 id d001 ~ d025, 본사 id h001 ~ h003, 비번 모두 1234
  Future<void> insertDefaultEmployeesIfEmpty() async {
    final db = await initializeDB();
    final existing = await db.query('employee');

    if (existing.isEmpty) {
      // 25개 대리점: 자치구청 위도/경도 사용
      await db.insert('employee', {
        'eid': 'd001',
        'ename': '강남구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5172,
        'elongdata': 127.0473,
      });
      await db.insert('employee', {
        'eid': 'd002',
        'ename': '강동구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5302,
        'elongdata': 127.1238,
      });
      await db.insert('employee', {
        'eid': 'd003',
        'ename': '강북구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.6396,
        'elongdata': 127.0256,
      });
      await db.insert('employee', {
        'eid': 'd004',
        'ename': '강서구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5509,
        'elongdata': 126.8495,
      });
      await db.insert('employee', {
        'eid': 'd005',
        'ename': '관악구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.4784,
        'elongdata': 126.9516,
      });
      await db.insert('employee', {
        'eid': 'd006',
        'ename': '광진구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5384,
        'elongdata': 127.0823,
      });
      await db.insert('employee', {
        'eid': 'd007',
        'ename': '구로구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.4954,
        'elongdata': 126.8874,
      });
      await db.insert('employee', {
        'eid': 'd008',
        'ename': '금천구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.4568,
        'elongdata': 126.8950,
      });
      await db.insert('employee', {
        'eid': 'd009',
        'ename': '노원구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.6542,
        'elongdata': 127.0568,
      });
      await db.insert('employee', {
        'eid': 'd010',
        'ename': '도봉구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.6688,
        'elongdata': 127.0472,
      });
      await db.insert('employee', {
        'eid': 'd011',
        'ename': '동대문구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5744,
        'elongdata': 127.0396,
      });
      await db.insert('employee', {
        'eid': 'd012',
        'ename': '동작구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5124,
        'elongdata': 126.9392,
      });
      await db.insert('employee', {
        'eid': 'd013',
        'ename': '마포구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5663,
        'elongdata': 126.9014,
      });
      await db.insert('employee', {
        'eid': 'd014',
        'ename': '서대문구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5791,
        'elongdata': 126.9368,
      });
      await db.insert('employee', {
        'eid': 'd015',
        'ename': '서초구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.4836,
        'elongdata': 127.0327,
      });
      await db.insert('employee', {
        'eid': 'd016',
        'ename': '성동구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5633,
        'elongdata': 127.0364,
      });
      await db.insert('employee', {
        'eid': 'd017',
        'ename': '성북구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5894,
        'elongdata': 127.0167,
      });
      await db.insert('employee', {
        'eid': 'd018',
        'ename': '송파구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5145,
        'elongdata': 127.1059,
      });
      await db.insert('employee', {
        'eid': 'd019',
        'ename': '양천구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5169,
        'elongdata': 126.8666,
      });
      await db.insert('employee', {
        'eid': 'd020',
        'ename': '영등포구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5263,
        'elongdata': 126.8962,
      });
      await db.insert('employee', {
        'eid': 'd021',
        'ename': '용산구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5323,
        'elongdata': 126.9909,
      });
      await db.insert('employee', {
        'eid': 'd022',
        'ename': '은평구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.6027,
        'elongdata': 126.9291,
      });
      await db.insert('employee', {
        'eid': 'd023',
        'ename': '종로구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5729,
        'elongdata': 126.9794,
      });
      await db.insert('employee', {
        'eid': 'd024',
        'ename': '중구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5636,
        'elongdata': 126.9972,
      });
      await db.insert('employee', {
        'eid': 'd025',
        'ename': '중랑구',
        'epassword': '1234',
        'epermission': 0,
        'elatdata': 37.5985,
        'elongdata': 127.0928,
      });

      // 본사 직원 3명 (사원, 팀장, 임원)
      await db.insert('employee', {
        'eid': 'h001',
        'ename': '본사사원',
        'epassword': '1234',
        'epermission': 1,
        'elatdata': null,
        'elongdata': null,
      });
      await db.insert('employee', {
        'eid': 'h002',
        'ename': '본사팀장',
        'epassword': '1234',
        'epermission': 2,
        'elatdata': null,
        'elongdata': null,
      });
      await db.insert('employee', {
        'eid': 'h003',
        'ename': '본사임원',
        'epassword': '1234',
        'epermission': 3,
        'elatdata': null,
        'elongdata': null,
      });
    }
  }

  // // factory에 2개 데이터 넣기
  // Future<void> insertDefaultFactoriesIfEmpty() async {
  //   final db = await initializeDB();
  //   final existing = await db.query('factory');

  //   if (existing.isEmpty) {
  //     await db.insert('factory', {
  //       'fid': 'f001',
  //       'fbrand': '나이키',
  //       'fphone': '02-1234-5678',
  //     });

  //     await db.insert('factory', {
  //       'fid': 'f002',
  //       'fbrand': '아디다스',
  //       'fphone': '02-8765-4321',
  //     });

  //             await db.insert('factory', {
  //         'fid': 'fac003',
  //         'fbrand': '뉴발란스',
  //         'fphone': '02-1111-0003',
  //       });

  //       await db.insert('factory', {
  //         'fid': 'fac004',
  //         'fbrand': '컨버스',
  //         'fphone': '02-1111-0004',
  //       });

  //       await db.insert('factory', {
  //         'fid': 'fac005',
  //         'fbrand': '리복',
  //         'fphone': '02-1111-0005',
  //       });
  //   }
  // }

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


  // 회원가입시 아이디 중복체크
  Future<bool> isCidDuplicate(String cid) async {
  final db = await initializeDB();
  final result = await db.query(
    'customer',
    where: 'cid = ?',
    whereArgs: [cid],
  );
  return result.isNotEmpty;
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

  // 특정날짜 데이터가져오는 매서드추가 2025.4.10 이런식으로기입
Future<List<Map<String, dynamic>>> getSalesByShop(String date) async {
  final db = await initializeDB();
  final result = await db.rawQuery('''
    SELECT 
      e.eid, 
      e.ename, 
      SUM(p.pprice * o.ocount) AS total 
    FROM orders o 
    JOIN product p ON o.opid = p.pid 
    JOIN employee e ON o.oeid = e.eid 
    WHERE substr(o.odate, 1, 10) = ?
    GROUP BY e.eid 
    ORDER BY total DESC
  ''', [date]);

  return result;
}

  Future<List<Product>> fetchInventory() async {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> products = await db.query(
      'product',
      orderBy: 'pstock', // 재고량 기준 오름차순 정렬
    );
    return products.map((map) => Product.fromMap(map)).toList();
  }
}
