// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _identitas()
          ],
        )
      ),
    );
  }

   _identitas() {
    return Column(
      children: [
        Text("\n"),
        Text("Ini adalah halaman Settings"),
        Text("\n"),
        Text("06TPLE004 - Kelompok 6"),
        Text("Angga Kurnia"),
        Text("Anjas Kosasih"),
        Text("Raden azka hermanto"),
        Text("Stevianus Imanuel Salangka"),
        Text("Unggul Prasetyo Utomo")
      ],
    );
  }
}

