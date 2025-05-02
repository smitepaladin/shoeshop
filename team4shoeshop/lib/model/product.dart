import 'dart:typed_data';

class Product{
    final int? id; // 신발 테이블 기본 id autoincrement
    final String pid; // 신발 ID
    final String pbrand; // 제품 브랜드
    final String pname; // 제품 이름
    final int psize; // 사이즈
    final String pcolor; // 색상
    final int pstock; // 재고
    final int pprice; // 가격
    final Uint8List pimage; // 이미지

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