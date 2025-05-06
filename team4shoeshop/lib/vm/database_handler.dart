import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:team4shoeshop/model/customer.dart';
import 'package:team4shoeshop/model/order.dart';
import 'package:team4shoeshop/model/product.dart';

class DatabaseHandler {
  Future<Database> initializeDB()async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'shoeshop.db'),
      onCreate: (db, version) async{

        // approval 테이블
        // final int? aid; // 품의번호 autoincrement
        // final String aeid; // 직원ID
        // final String afid; // 제조사ID
        // final int abaljoo; // 발주량
        // final int asoojoo; // 수주량
        // final String astatus; // 품의상태
        // final String adate; // 품의 요청일
        // final String ateamappdate; // 팀장 결재일
        // final String achiefappdate; // 임원 결재일

        await db.execute(
        "create table approval(aid integer primary key autoincrement, aeid text, afid text, abaljoo integer, asoojoo integer, astatus text, adate text, ateamappdate text, achiefappdate text)");

          //customer 테이블
          // final int? id; // 고객 테이블 기본 id autoincrement
          // final String cid; // 고객 id
          // final String cname; // 고객 이름
          // final String cpassword; // 고객 비밀번호
          // final String cphone; // 고객 전화번호
          // final String cemail; // 고객 이메일
          // final String caddress; // 고객 주소(실시간주소 아님)
          // final int ccardnum; // 고객 카드번호
          // final int ccardcvc; // 고객 CVC번호
          // final int ccarddate; // 고객 카드 유효기간

        await db.execute(
        "create table customer(id integer primary key autoincrement, cid text, cname text, cpassword text, cphone text, cemail text, caddress text, ccardnum integer, ccardcvc integer, ccarddate integer)");

        // customer 초기 데이터
        await db.insert('customer', {
          'cid': 'cust001',
          'cname': '홍길동',
          'cpassword': '1234',
          'cphone': '01012345678',
          'cemail': 'hong@example.com',
          'caddress': '서울시 강남구',
          'ccardnum': 1234567890123456,
          'ccardcvc': 123,
          'ccarddate': 2506
        });

          // employee 테이블
          // final String eid; // 직원 ID
          // final String ename; // 직원 이름
          // final String epassword; // 직원 비밀번호
          // final int epermission; // 직원 직위(0대리점주, 1사원, 2팀장, 3임원)
          // final double elatdata; // 대리점 위도
          // final double elongdata; // 대리점 경도

        await db.execute(
        "create table employee(eid text primary key, ename text, epassword text, epermission integer, elatdate real, elongdata real)");
          
          // factory 테이블
          // final String fid; //  제조사 ID
          // final String fbrand; // 제조사 브랜드
          // final String fphone; // 제조사 전화번호

        await db.execute(
        "create table factory(fid text primary key, fbrand text, fphone text)");
          
        // factory 초기 데이터
        await db.insert('factory', {
          'fid': 'fac001',
          'fbrand': '나이키',
          'fphone': '02-1111-0001'
        });

        await db.insert('factory', {
          'fid': 'fac002',
          'fbrand': '아디다스',
          'fphone': '02-1111-0002'
        });

        await db.insert('factory', {
          'fid': 'fac003',
          'fbrand': '뉴발란스',
          'fphone': '02-1111-0003'
        });

        await db.insert('factory', {
          'fid': 'fac004',
          'fbrand': '컨버스',
          'fphone': '02-1111-0004'
        });

        await db.insert('factory', {
          'fid': 'fac005',
          'fbrand': '리복',
          'fphone': '02-1111-0005'
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

        await db.execute(
        "create table order(oid integer primary key autoincrement, ocid text, opid text, oeid text, ocount integer, odate text, ostatus text, ocartbool integer, oreturncount integer, oreturndate text, oreturnstatus text, odefectivereason text, oreason text)");

        // order 초기 데이터
        // 전월 주문 - 4월
        await db.insert('"order"', {
          'ocid': 'cust001',
          'opid': 'prd001', // 에어맥스
          'oeid': 'emp001', // 김사원
          'ocount': 2,
          'odate': '2025-04-10',
          'ostatus': '수령',
          'ocartbool': 0,
          'oreturncount': 0,
          'oreturndate': '',
          'oreturnstatus': '',
          'odefectivereason': '',
          'oreason': ''
        });

        await db.insert('"order"', {
          'ocid': 'cust001',
          'opid': 'prd002', // 울트라부스트
          'oeid': 'emp002', // 박팀장
          'ocount': 1,
          'odate': '2025-04-25',
          'ostatus': '수령',
          'ocartbool': 0,
          'oreturncount': 0,
          'oreturndate': '',
          'oreturnstatus': '',
          'odefectivereason': '',
          'oreason': ''
        });

        // 당월 주문 - 5월
        await db.insert('"order"', {
          'ocid': 'cust001',
          'opid': 'prd003', // 990v5
          'oeid': 'emp001',
          'ocount': 3,
          'odate': '2025-05-01',
          'ostatus': '발송',
          'ocartbool': 0,
          'oreturncount': 0,
          'oreturndate': '',
          'oreturnstatus': '',
          'odefectivereason': '',
          'oreason': ''
        });

        await db.insert('"order"', {
          'ocid': 'cust001',
          'opid': 'prd004', // 척테일러
          'oeid': 'emp003', // 이이사
          'ocount': 1,
          'odate': '2025-05-02',
          'ostatus': '발송',
          'ocartbool': 0,
          'oreturncount': 0,
          'oreturndate': '',
          'oreturnstatus': '',
          'odefectivereason': '',
          'oreason': ''
        });

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

        await db.execute(
        "create table product(id integer primary key autoincrement, pid text, pbrand text, pname text, psize integer, pcolor text, pstock integer, pprice integer, pimage blob)");
        
        // product 초기 데이터 (이미지는 null로 초기 삽입)
        await db.insert('product', {
          'pid': 'prd001',
          'pbrand': '나이키',
          'pname': '에어맥스',
          'psize': 270,
          'pcolor': '검정',
          'pstock': 50,
          'pprice': 129000,
          'pimage': null
        });

        await db.insert('product', {
          'pid': 'prd002',
          'pbrand': '아디다스',
          'pname': '울트라부스트',
          'psize': 265,
          'pcolor': '흰색',
          'pstock': 30,
          'pprice': 139000,
          'pimage': null
        });

        await db.insert('product', {
          'pid': 'prd003',
          'pbrand': '뉴발란스',
          'pname': '990v5',
          'psize': 280,
          'pcolor': '회색',
          'pstock': 40,
          'pprice': 159000,
          'pimage': null
        });

        await db.insert('product', {
          'pid': 'prd004',
          'pbrand': '컨버스',
          'pname': '척테일러',
          'psize': 260,
          'pcolor': '빨강',
          'pstock': 60,
          'pprice': 69000,
          'pimage': null
        });

        await db.insert('product', {
          'pid': 'prd005',
          'pbrand': '리복',
          'pname': '클래식레더',
          'psize': 275,
          'pcolor': '네이비',
          'pstock': 35,
          'pprice': 99000,
          'pimage': null
        });

      },
      version: 1,
    );
  } // Database

// 로그인 시 나오는 첫 화면
Future<List<Product>> getAllproducts() async{
  final Database db = await initializeDB();
  final List<Map<String, dynamic>> queryResult = await db. rawQuery(
    'select * from product order by name'
  );
  return queryResult.map((e) => Product.fromMap(e)).toList();
}

// 드로우바 내 결제내역 페이지
Future<List<Order>> getAllorders() async{
  final Database db = await initializeDB();
  final List<Map<String, dynamic>> queryResult = await db.rawQuery(
    'select*from product where order order by odate'
  );
  return queryResult.map((e) =>  Order.fromMap(e)).toList();
}

// 주문의 상품 db로 상품 상세 정보 가지고 오기(주문내역에서 필요요)
Future<Product?> getProductByPid(String pid) async {
  final Database db = await initializeDB();
  final List<Map<String, dynamic>> queryResult = await db.rawQuery(
    'select*from product where pid=?',
    [pid]
  );
  if (queryResult.isNotEmpty) {
    return Product.fromMap(queryResult.first);
  }
  return null;
}

    // 회원가입 페이지에서 받은 정보 customer table에 넣기
    Future<int> insertJoin(Customer customer) async{
    int result = 0;
    final Database db = await initializeDB();
    result = await db.rawInsert(
      'insert into customer(cid, cname, cpassword, cphone, cemail, caddress) values (?,?,?,?,?,?)',
      [customer.cid, customer.cname, customer.cpassword, customer.cphone, customer.cemail, customer.caddress]
    );
    return result;
  }



}