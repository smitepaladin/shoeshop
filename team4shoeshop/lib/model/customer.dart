class Customer{

    final int? id; // 고객 테이블 기본 id autoincrement
    final String cid; // 고객 id
    final String cname; // 고객 이름
    final String cpassword; // 고객 비밀번호
    final String cphone; // 고객 전화번호
    final String cemail; // 고객 이메일
    final String caddress; // 고객 주소(실시간주소 아님)
    final int ccardnum; // 고객 카드번호
    final int ccardcvc; // 고객 CVC번호
    final int ccarddate; // 고객 카드 유효기간

  Customer({
    this.id,
    required this.cid,
    required this.cname,
    required this.cpassword,
    required this.cphone,
    required this.cemail,
    required this.caddress,
    required this.ccardnum,
    required this.ccardcvc,
    required this.ccarddate
    }
  );

  Customer.fromMap(Map<String, dynamic> res)
  : id = res['id'],
  cid = res['cid'],
  cname = res['cname'],
  cpassword = res['cpassword'],
  cphone = res['cphone'],
  cemail = res['cemail'],
  caddress = res['caddress'],
  ccardnum = res['ccardnum'],
  ccardcvc = res['ccardcvc'],
  ccarddate = res['ccarddate'];
}