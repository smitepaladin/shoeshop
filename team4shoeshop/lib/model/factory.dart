class Factory{
    final String fid; //  제조사 ID
    final String fbrand; // 제조사 브랜드
    final String fphone; // 제조사 전화번호


  Factory({
    required this.fid,
    required this.fbrand,
    required this.fphone,
    }
  );

  Factory.fromMap(Map<String, dynamic> res)
  : fid  = res['fid'],
  fbrand = res['fbrand'],
  fphone = res['fphone'];
}