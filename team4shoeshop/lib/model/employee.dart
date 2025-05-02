class Employee{
    final String eid; // 직원 ID
    final String ename; // 직원 이름
    final String epassword; // 직원 비밀번호
    final int epermission; // 직원 직위(0대리점주, 1사원, 2팀장, 3임원)
    final double elatdata; // 대리점 위도
    final double elongdata; // 대리점 경도


  Employee({
    required this.eid,
    required this.ename,
    required this.epassword,
    required this.epermission,
    required this.elatdata,
    required this.elongdata,
    }
  );

  Employee.fromMap(Map<String, dynamic> res)
  : eid = res['eid'],
  ename = res['ename'],
  epassword = res['epassword'],
  epermission = res['epermission'],
  elatdata = res['elatdata'],
  elongdata = res['elongdata'];
}