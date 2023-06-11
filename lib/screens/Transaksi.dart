// ignore_for_file: file_names

import 'package:escape/models/TransaksiModel.dart';
import 'package:flutter/material.dart';
import '../models/TransaksiModel.dart';
import '../models/TransaksiBarangModel.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final List<Transaksi> _daftarTransaksi = [
    Transaksi(kasir: 'Administrator', total: 32000, bayar: 50000, kembali: 18000, jam: '2023-05-19 8:40:23'),
    Transaksi(kasir: 'Unggul P', total: 13000, bayar: 15000, kembali: 2000, jam: '2023-05-19 9:50:23'),
    Transaksi(kasir: 'Unggul P', total: 30000, bayar: 50000, kembali: 20000, jam: '2023-05-20 17:00:23'),
    Transaksi(kasir: 'Angga K', total: 5000, bayar: 100000, kembali: 95000, jam: '2023-05-21 8:22:23'),
    Transaksi(kasir: 'Angga K', total: 2000, bayar: 50000, kembali: 48000, jam: '2023-05-21 21:40:23'),
  ];
  final _listBarang = <TransaksiBarang>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Transaksi"),
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
                  label: Text('Kasir'),
                ),
                DataColumn(
                  label: Text('Jam Transaksi'),
                ),
                DataColumn(
                  label: Text('Total Harga'),
                ),
                DataColumn(
                  label: Text('Bayar'),
                ),
                DataColumn(
                  label: Text('Kembali'),
                ),
                DataColumn(
                  label: Text('Aksi'),
                ),
              ],
              rows: _daftarTransaksi
                  .asMap()
                  .entries
                  .map((entry) => DataRow(
                      cells: [
                        DataCell(Text('${entry.key + 1}')),
                        DataCell(Text(entry.value.kasir)),
                        DataCell(Text(entry.value.jam)),
                        DataCell(Text(entry.value.total.toString())),
                        DataCell(Text(entry.value.bayar.toString())),
                        DataCell(Text(entry.value.kembali.toString())),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _daftarTransaksi.removeAt(entry.key);
                            });
                          },
                        )),
                      ],
                      onSelectChanged: (selected) {
                        // insert your navigation function here and use the selected value returned by the function
                        Navigator.pushNamed(
                          context,
                          '/invoice',
                          arguments: {
                            'namaPembeli': entry.value.kasir,
                            'totalHarga': entry.value.total,
                            'bayar' : entry.value.bayar,
                            'jam' : entry.value.jam,
                            'listBarang': _listBarang,
                          },
                        );
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
          Navigator.pushNamed(context, '/create');
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


