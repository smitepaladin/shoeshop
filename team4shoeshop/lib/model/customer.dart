class Customer{
  final int? id;
  final String cid;
  final String cname;
  final String cpassword;
  final int cphone;
  final String cemail;
  final int ccardnum;
  final int ccardcvc;
  final int ccarddate;

  Customer({
    this.id,
    required this.cid,
    required this.cname,
    required this.cpassword,
    required this.cphone,
    required this.cemail,
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
  ccardnum = res['ccardnum'],
  ccardcvc = res['ccardcvc'],
  ccarddate = res['ccardate'];
}