import 'package:flutter/material.dart';

class BarangDetail extends StatefulWidget {
  final String? nama;
  final String? kategori;
  final int? harga;

  const BarangDetail({
    Key? key,
    this.nama,
    this.kategori,
    this.harga,
  }) : super(key: key);

  @override
  _BarangDetailState createState() => _BarangDetailState();
}

class _BarangDetailState extends State<BarangDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Barang'),
      ),
      body: Column(
        children: [
          Text("Nama Menu : ${widget.nama}"),
          Text("Kategori : ${widget.kategori}"),
          Text("Harga : ${widget.harga}")
        ],
      ),
    );
  }
}
