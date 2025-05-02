class Factory{
  final String fid;
  final String fbrand;
  final String fphone;


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