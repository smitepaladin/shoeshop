class Approval{
    final int? aid; // 품의번호 autoincrement
    final String aeid; // 직원ID
    final String afid; // 제조사ID
    final int abaljoo; // 발주량
    final int asoojoo; // 수주량
    final String astatus; // 품의상태
    final String adate; // 품의 요청일
    final String ateamappdate; // 팀장 결재일
    final String achiefappdate; // 임원 결재일
    final String apid; // 주문해야할 신발 id
Approval({
    this.aid,
    required this.aeid,
    required this.afid,
    required this.abaljoo,
    required this.asoojoo,
    required this.astatus,
    required this.adate,
    required this.ateamappdate,
    required this.achiefappdate,
    required this.apid
    }
  );

  Approval.fromMap(Map<String, dynamic> res)
  : aid = res['aid'],
  aeid = res['aeid'],
  afid = res['afid'],
  abaljoo = res['abaljoo'],
  asoojoo = res['asoojoo'],
  astatus = res['astatus'],
  adate = res['adate'],
  ateamappdate = res['ateamappdate'],
  achiefappdate = res['achiefappdate'],
  apid = res['apid'];
}