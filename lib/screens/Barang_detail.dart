import 'package:flutter/material.dart';

class BarangDetail extends StatefulWidget {
  final String? Nama;
  final String? Kategori;
  final int? Harga;

  const BarangDetail({
    Key? key,
    this.Nama,
    this.Kategori,
    this.Harga,
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
          Text("Nama Menu : ${widget.Nama}"),
          Text("Kategori : ${widget.Kategori}"),
          Text("Harga : ${widget.Harga}")
        ],
      ),
    );
  }
}
