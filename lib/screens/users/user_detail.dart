import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  final String? id;
  final String? nama;
  final String? alamat;

  const UserDetail({
    Key? key,
    this.id,
    this.nama,
    this.alamat,
  }) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail User'),
      ),
      body: Column(
        children: [
          Text("Nama User : ${widget.id}"),
          Text("Merk : ${widget.nama}"),
          Text("Harga User : ${widget.alamat}")
          
        ],
      ),
    );
  }
}
