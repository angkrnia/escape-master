import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        },
        child: const Text('Simpan')
      ),
    );
  }
}
