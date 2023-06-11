// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../models/BarangModel.dart';
import 'package:escape/screens/Barang_detail.dart';

class BarangScreen extends StatefulWidget {
  const BarangScreen({super.key});

  @override
  State<BarangScreen> createState() => _BarangScreenState();
}

class _BarangScreenState extends State<BarangScreen> {
  final List<Barang> _daftarBarang = [
    Barang(nama: 'Ayam Geprek', kategori: 'makanan', harga: 18000),
    Barang(nama: 'Nasi Goreng', kategori: 'makanan', harga: 15000),
    Barang(nama: 'Aqua', kategori: 'minuman', harga: 5000),
    Barang(nama: 'Tea Jus', kategori: 'minuman', harga: 5000),
    Barang(nama: 'Kopi', kategori: 'minuman', harga: 5000),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Makanan"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              showCheckboxColumn: false,
              columnSpacing: 16.0, // Jarak antara kolom
              columns: const [
                DataColumn(
                  label: Text('No.'),
                ),
                DataColumn(
                  label: Text('Nama Barang'),
                ),
                DataColumn(
                  label: Text('Kategori'),
                ),
                DataColumn(
                  label: Text('Harga'),
                ),
                DataColumn(
                  label: Text('Aksi'),
                ),
              ],
              rows: _daftarBarang
                  .asMap()
                  .entries
                  .map((entry) => DataRow(
                      cells: [
                        DataCell(Text('${entry.key + 1}')),
                        DataCell(Text(entry.value.nama)),
                        DataCell(Text(entry.value.kategori)),
                        DataCell(Text(entry.value.harga.toString())),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _daftarBarang.removeAt(entry.key);
                            });
                          },
                        )),
                      ],
                      onSelectChanged: (selected) {
                        // insert your navigation function here and use the selected value returned by the function
                        //Navigator.pushNamed(context, '/home');
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BarangDetail(
                          Nama: entry.value.nama,
                          Kategori: entry.value.kategori,
                          Harga: entry.value.harga,
                          )));
                      }
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                _selectTab('home');
              },
            ),
            const SizedBox(width: 40), // Mengatur jarak antara menu utama
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _selectTab('logout');
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/barangform');
        },
      ),
    );
  }

  void _selectTab(String index) {
    if (index == 'home') {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else if (index == 'logout') {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}


