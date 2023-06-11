import 'dart:io';
import 'package:escape/screens/User_detail.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _IdTextboxController = TextEditingController();
  final _NamaTextboxController = TextEditingController();
  final _AlamatTextboxController = TextEditingController();
  final _PasswordTextboxController = TextEditingController();
  XFile? _image;

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
            _textboxId(),
            _textboxPassword(),
            _textboxNama(),
            _textboxAlamat(),
            _tombolUploadFoto(),
            _tombolSimpan(),
          ],
        ),
      ),
    );
  }

  _textboxId() {
    return TextField(
      decoration: const InputDecoration(
          labelText: "ID", contentPadding: EdgeInsets.all(12)),
      controller: _IdTextboxController,
    );
  }

  _textboxPassword() {
    return TextField(
      obscureText: true,
      decoration: const InputDecoration(
          labelText: "Password", contentPadding: EdgeInsets.all(12)),
      controller: _PasswordTextboxController,
    );
  }

  _textboxNama() {
    return TextField(
      decoration: const InputDecoration(
          labelText: "Nama User", contentPadding: EdgeInsets.all(12)),
      controller: _NamaTextboxController,
    );
  }

  _textboxAlamat() {
    return TextField(
      decoration: const InputDecoration(
          labelText: "Alamat", contentPadding: EdgeInsets.all(12)),
      keyboardType: TextInputType.number,
      controller: _AlamatTextboxController,
    );
  }

  _tombolSimpan() {
    return ElevatedButton(
        onPressed: () {
          if (_IdTextboxController.text.isEmpty ||
              _NamaTextboxController.text.isEmpty ||
              _AlamatTextboxController.text.isEmpty) {
            Fluttertoast.showToast(
                msg: "Data belum lengkap!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red,
                textColor: Colors.white);
            return;
          }

          if (_IdTextboxController.text.length < 3) {
            Fluttertoast.showToast(
                msg: "ID User minimal 3 karakter",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red,
                textColor: Colors.white);
            return;
          }

          String ID = _IdTextboxController.text;
          String Nama = _NamaTextboxController.text;
          String Alamat = _AlamatTextboxController.text;

          // pindah ke halaman User Detail dan mengirim data
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserDetail(
                    id: ID,
                    nama: Nama,
                    alamat: Alamat,
                  )));
        },
        child: const Text('Simpan'));
  }

  _tombolUploadFoto() {
    final _picker = ImagePicker();
    XFile? _image;

    void _getImage() async {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.camera); // Mengambil gambar dari galeri
      // final pickedFile = await _picker.pickImage(source: ImageSource.camera); // Mengambil gambar dari kamera
      setState(() {
        _image = pickedFile;
      });
    }

    return Column(
      children: [
        ElevatedButton(
          onPressed: _getImage,
          child: Text('Gambar'),
        ),
        if (_image != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.file(File(_image!.path)),
                Text('Foto yang sudah diupload'),
              ],
            ),
          ),
      ],
    );
  }
}
