class Order{

    final int? oid; // 주분번호 autoincrement
    final String ocid; // 고객 ID
    final String opid; // 신발 ID
    final String oeid; // 직원 ID
    final int ocount; // 주문수량
    final String odate; // 주문일자
    final String ostatus; // 상품 상태(발송 도착 수령)
    final bool ocartbool; // 장바구니 여부
    final int oreturncount; // 반품수량
    final String oreturndate; // 반품일
    final String oreturnstatus; // 반품 상태(반품, 제조사 발송)
    final String odefectivereason; // 제조사 규명 하자 내용
    final String oreason; // 반품 이유

  Order({
    this.oid,
    required this.ocid,
    required this.opid,
    required this.oeid,
    required this.ocount,
    required this.odate,
    required this.ostatus,
    required this.ocartbool,
    required this.oreturncount,
    required this.oreturndate,
    required this.oreturnstatus,
    required this.odefectivereason,
    required this.oreason
    }
  );

  Order.fromMap(Map<String, dynamic> res)
  : oid = res['oid'],
  ocid = res['ocid'],
  opid = res['opid'],
  oeid = res['oeid'],
  ocount = res['ocount'],
  odate = res['odate'],
  ostatus = res['ostatus'],
  ocartbool = res['ocartbool'],
  oreturncount = res['oreturncount'],
  oreturndate = res['oreturndate'],
  oreturnstatus = res['oreturnstatus'],
  odefectivereason = res['odefectivereason'],
  oreason = res['oreason'];


    Map<String, dynamic> toMap() {
    return {
      'oid': oid,
      'ocid': ocid,
      'opid': opid,
      'oeid': oeid,
      'ocount': ocount,
      'odate': odate,
      'ostatus': ostatus,
      'ocartbool': ocartbool ? 1 : 0,
      'oreturncount': oreturncount,
      'oreturndate': oreturndate,
      'oreturnstatus': oreturnstatus,
      'odefectivereason': odefectivereason,
      'oreason': oreason,
    };
  }
}