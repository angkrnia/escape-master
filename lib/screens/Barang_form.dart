import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:escape/models/category_model.dart';
import '../api/category_service.dart';
import 'package:escape/screens/Barang_detail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BarangForm extends StatefulWidget {
  const BarangForm({Key? key}) : super(key: key);

  @override
  _BarangFormState createState() => _BarangFormState();
}

class _BarangFormState extends State<BarangForm> {
  List<Category> _categories = [];
  TextEditingController _menuNameController = TextEditingController();
  TextEditingController _menuPriceController = TextEditingController();
  int _categoryId = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      CategoryService categoryService = CategoryService();
      List<Category> categoryList = await categoryService.getMenu();
      setState(() {
        _categories = categoryList;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Menu Baru'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _textboxNamaBarang(),
            SizedBox(height: 16.0),
            _textboxHarga(),
            SizedBox(height: 16.0),
            DropdownButtonFormField<int>(
              value: _categories.length > 0 ? _categories[0].id : null,
              items: _categories.map((Category category) {
                return DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  _categoryId = value!;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                submitMenu();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  _textboxNamaBarang() {
    return TextField(
      decoration: const InputDecoration(
          labelText: "Nama Menu", contentPadding: EdgeInsets.all(12)),
      controller: _menuNameController,
    );
  }

  _textboxHarga() {
    return TextField(
      decoration: const InputDecoration(
          labelText: "Harga", contentPadding: EdgeInsets.all(12)),
      keyboardType: TextInputType.number,
      controller: _menuPriceController,
    );
  }

  Future<void> submitMenu() async {
    final url = Uri.parse('https://calm-red-dove-fez.cyclic.app/menu');
    final response = await http.post(url, body: {
      'name': _menuNameController.text,
      'price': _menuPriceController.text,
      'category_id': _categoryId.toString(),
    });

    if (response.statusCode == 201) {
      print("berhasil");
    } else {
      print("gagal");
    }
  }
}
