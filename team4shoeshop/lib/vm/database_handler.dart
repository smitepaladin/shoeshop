import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
          // final String oreturnstatus; // 반품 상태(반품, 제조사 발송)
          // final String odefectivereason; // 제조사 규명 하자 내용
          // final String oreason; // 반품 이유

        await db.execute(
        "create table order(oid integer primary key autoincrement, ocid text, opid text, oeid text, ocount integer, odate text, ostatus text, ocartbool integer, oreturncount integer, oreturndate text, oreturnstatus text, odefectivereason text, oreason text)");

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
      },
      version: 1,
    );
  }



}