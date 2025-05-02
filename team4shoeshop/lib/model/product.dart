import 'dart:typed_data';

class Product{
  final int? id;
  final String pid;
  final String pbrand;
  final String pname;
  final int psize;
  final String pcolor;
  final int pstock;
  final int pprice;
  final Uint8List pimage;

  Product({
    this.id,
    required this.pid,
    required this.pbrand,
    required this.pname,
    required this.psize,
    required this.pcolor,
    required this.pstock,
    required this.pprice,
    required this.pimage
    }
  );

  Product.fromMap(Map<String, dynamic> res)
  : id = res['id'],
  pid = res['pid'],
  pbrand = res['pbrand'],
  pname = res['pname'],
  psize = res['psize'],
  pcolor = res['pcolor'],
  pstock = res['pstock'],
  pprice = res['pprice'],
  pimage = res['pimage'];
}