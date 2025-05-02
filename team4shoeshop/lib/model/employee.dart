class Employee{
  final String eid;
  final String ename;
  final String epassword;
  final int epermission;
  final double elatdata;
  final double elongdata;


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