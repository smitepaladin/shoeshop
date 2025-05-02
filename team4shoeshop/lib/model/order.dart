class Order{
  final int? oid;
  final String oid;
  final String opcid;
  final String oeid;
  final int ;
  final String cemail;
  final int ccardnum;
  final int ccardcvc;
  final int ccarddate;
  final int ccarddate;
  final int ccarddate;
  final int ccarddate;
  final int ccarddate;

  Order({
    this.id,
    required this.cid,
    required this.cname,
    required this.cpassword,
    required this.cphone,
    required this.cemail,
    required this.ccardnum,
    required this.ccardcvc,
    required this.ccarddate
    required this.ccarddate
    required this.ccarddate
    required this.ccarddate
    required this.ccarddate
    }
  );

  Order.fromMap(Map<String, dynamic> res)
  : id = res['id'],
  cid = res['cid'],
  cname = res['cname'],
  cpassword = res['cpassword'],
  cphone = res['cphone'],
  cemail = res['cemail'],
  ccardnum = res['ccardnum'],
  ccardcvc = res['ccardcvc'],
  ccardcvc = res['ccardcvc'],
  ccardcvc = res['ccardcvc'],
  ccardcvc = res['ccardcvc'],
  ccardcvc = res['ccardcvc'],
  ccarddate = res['ccardate'];
}