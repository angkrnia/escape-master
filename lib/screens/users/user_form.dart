// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _fullnameTextboxController = TextEditingController();
  final _usernameTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();
  bool _obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _textboxFullname(),
            const SizedBox(height: 14.0,),
            _textboxUsername(),
            const SizedBox(height: 14.0,),
            _textboxPassword(),
            const SizedBox(height: 14.0,),
            _tombolSimpan(),
          ],
        ),
      ),
    );
  }

  _textboxPassword() {
    return TextField(
      obscureText: _obsecureText,
      controller: _passwordTextboxController,
      decoration: InputDecoration(
        icon: const Icon(Icons.lock, size: 35),
        labelText: 'Password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obsecureText = !_obsecureText;
            });
          },
          icon: Icon(
            _obsecureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }

  _textboxUsername() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Username',
        icon: Icon(Icons.person, size: 35),
        border: OutlineInputBorder(),
      ),
      controller: _usernameTextboxController,
    );
  }

  _textboxFullname() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Fullname',
        icon: Icon(Icons.person, size: 35),
        border: OutlineInputBorder(),
      ),
      controller: _fullnameTextboxController,
    );
  }

  _tombolSimpan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: ElevatedButton(
        onPressed: () {
          String fullname = _fullnameTextboxController.text;
          String username = _usernameTextboxController.text;
          String password = _passwordTextboxController.text;
          if (fullname.isEmpty || username.isEmpty || password.isEmpty) {
            Fluttertoast.showToast(
              msg: "Mohon isi semua field",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
            return;
          }
          submitUser();
        },
        child: const Text('Simpan')
      ),
    );
  }

  Future<void> submitUser() async {
    try {
      final uri = Uri.parse('https://calm-red-dove-fez.cyclic.app/users');
      final response = await http.post(
        uri,
        body: {
          'fullname': _fullnameTextboxController.text,
          'username': _usernameTextboxController.text,
          'password': _passwordTextboxController.text,
        },
      );
      if (response.statusCode == 200) {
        final js = json.decode(response.body);
        final result = js['data']['id'] ?? 0;
        if (result != null) {
          Fluttertoast.showToast(
            msg: "User berhasil ditambahkan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
          Navigator.pushNamedAndRemoveUntil(
              context, '/user', (route) => false);
        } else {
          throw Exception("API response does not contain 'id' data");
        }
      } else {
        throw Exception(
            "Error hit API status code not 200: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error hit API: ${e.toString()}");
    }
  }
}
