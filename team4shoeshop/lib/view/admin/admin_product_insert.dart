import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team4shoeshop/vm/database_handler.dart';

class AdminProductInsert extends StatefulWidget {
  const AdminProductInsert({super.key});

  @override
  State<AdminProductInsert> createState() => _AdminProductInsertState();
}

class _AdminProductInsertState extends State<AdminProductInsert> {
  final handler = DatabaseHandler();
  final box = GetStorage();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController pidController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  XFile? selectedImage;

  final List<String> brands = ['나이키', '아디다스', '뉴발란스', '푸마'];
  final List<String> sizes = ['230', '240', '250', '260', '270', 'Free'];
  final List<String> colors = ['블랙', '화이트', '레드', '블루', '그린', '옐로우'];

  String? selectedBrand;
  String? selectedSize;
  String? selectedColor;

  bool isHQUser() {
    final eid = box.read('adminId') ?? '';
    return ['h001', 'h002', 'h003'].contains(eid);
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await handler.initializeDB();

    try {
      await db.insert('product', {
        'pid': pidController.text,
        'pname': nameController.text,
        'pprice': int.tryParse(priceController.text) ?? 0,
        'pstock': int.tryParse(stockController.text) ?? 0,
        'pimage': selectedImage?.path ?? '', // ✅ 경로 String 저장
        'pbrand': selectedBrand ?? '',
        'psize': selectedSize ?? '',
        'pcolor': selectedColor ?? '',
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상품이 등록되었습니다')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('상품 등록 실패: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHQUser()) {
      return Scaffold(
        appBar: AppBar(title: const Text('상품 등록')),
        body: const Center(child: Text('접근 권한이 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('신규 상품 등록')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(pidController, '상품 ID'),
              buildTextField(nameController, '상품명'),
              buildTextField(priceController, '가격', isNumber: true),
              buildTextField(stockController, '재고 수량', isNumber: true),
              const SizedBox(height: 12),

              // 브랜드 드롭다운
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '브랜드명',
                  border: OutlineInputBorder(),
                ),
                value: selectedBrand,
                items: brands
                    .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (val) => setState(() => selectedBrand = val),
                validator: (value) =>
                    value == null ? '브랜드를 선택하세요' : null,
              ),
              const SizedBox(height: 12),

              // 사이즈 드롭다운
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '사이즈',
                  border: OutlineInputBorder(),
                ),
                value: selectedSize,
                items: sizes
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => selectedSize = val),
                validator: (value) =>
                    value == null ? '사이즈를 선택하세요' : null,
              ),
              const SizedBox(height: 12),

              // 색상 드롭다운
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: '색상',
                  border: OutlineInputBorder(),
                ),
                value: selectedColor,
                items: colors
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => selectedColor = val),
                validator: (value) =>
                    value == null ? '색상을 선택하세요' : null,
              ),
              const SizedBox(height: 12),

              // 이미지 미리보기
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey[100],
                  ),
                  alignment: Alignment.center,
                  child: selectedImage != null
                      ? Image.file(File(selectedImage!.path), fit: BoxFit.cover)
                      : const Text('이미지를 선택하려면 탭하세요'),
                ),
              ),
              const SizedBox(height: 20),

              // 등록 버튼
              ElevatedButton(
                onPressed: saveProduct,
                child: const Text('상품 등록'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label을(를) 입력하세요';
          }
          return null;
        },
      ),
    );
  }
}
