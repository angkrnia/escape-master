import 'dart:io';
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
  final _NamaBarangTextboxController = TextEditingController();
  final _KategoriTextboxController = TextEditingController();
  final _HargaTextboxController = TextEditingController();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Barang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _textboxNamaBarang(),
            _textboxKategori(),
            _textboxHarga(),
            _tombolUploadFoto(),
            _tombolSimpan(),
          ],
        ),
      ),
    );
  }

  _textboxNamaBarang() {
    return TextField(
      decoration: const InputDecoration(
          labelText: "Nama Menu", contentPadding: EdgeInsets.all(12)),
      controller: _NamaBarangTextboxController,
    );
  }

  _textboxKategori() {
    return TextField(
      decoration: const InputDecoration(
          labelText: "Kategori", contentPadding: EdgeInsets.all(12)),
      controller: _KategoriTextboxController,
    );
  }

  _textboxHarga() {
    return TextField(
      decoration: const InputDecoration(
          labelText: "Harga", contentPadding: EdgeInsets.all(12)),
      keyboardType: TextInputType.number,
      controller: _HargaTextboxController,
    );
  }

  _tombolSimpan() {
    return ElevatedButton(
        onPressed: () {
          if (_NamaBarangTextboxController.text.isEmpty ||
              _KategoriTextboxController.text.isEmpty ||
              _HargaTextboxController.text.isEmpty) {
            Fluttertoast.showToast(
                msg: "Data belum lengkap!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red,
                textColor: Colors.white);
            return;
          }

          if (_NamaBarangTextboxController.text.length < 3) {
            Fluttertoast.showToast(
                msg: "Nama Barang minimal 3 karakter",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.red,
                textColor: Colors.white);
            return;
          }

          String NamaBarang = _NamaBarangTextboxController.text;
          String Kategori = _KategoriTextboxController.text;
          int Harga = int.parse(_HargaTextboxController.text);

          // pindah ke halaman Barang Detail dan mengirim data
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BarangDetail(
                    Nama: NamaBarang,
                    Kategori: NamaBarang,
                    Harga: Harga,
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
