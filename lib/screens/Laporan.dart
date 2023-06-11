// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan"),
      ),
      body: const Center(
        child: Text("Ini Halaman Laporan"),
      ),
    );
  }
}