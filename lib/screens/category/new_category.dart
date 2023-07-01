import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewCategory extends StatefulWidget {
  const NewCategory({super.key});

  @override
  State<NewCategory> createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {

  final TextEditingController _nameController = TextEditingController();

  Future<void> submitCategory() async {
    try {
      final uri = Uri.parse('https://calm-red-dove-fez.cyclic.app/categories');
      final body = {
        'name': _nameController.text,
      };
      final response = await http.post(uri, body: json.encode(body), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: "New Category berhasil ditambahkan",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white);
        Navigator.pushNamedAndRemoveUntil(context, '/category', (route) => false);
      } else {
        Fluttertoast.showToast(
            msg: "New Category gagal ditambahkan",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
          msg: "New Category gagal ditambahkan",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    }
  }

  _textboxCategoryName(){
    return TextField(
      decoration: const InputDecoration(
      labelText: "Category Name", contentPadding: EdgeInsets.all(12)),
      controller: _nameController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _textboxCategoryName(),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                submitCategory();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}