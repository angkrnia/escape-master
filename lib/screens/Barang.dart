// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import '../api/menu_service.dart';
import 'package:escape/screens/Barang_detail.dart';

class BarangScreen extends StatefulWidget {
  const BarangScreen({super.key});

  @override
  State<BarangScreen> createState() => _BarangScreenState();
}

class _BarangScreenState extends State<BarangScreen> {
  List<Menu> _daftarBarang = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      MenuService menuService = MenuService();
      List<Menu> menuList = await menuService.getMenu();
      setState(() {
        _daftarBarang = menuList;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_daftarBarang.isEmpty) {
      // Tampilkan widget atau indikator loading saat data masih diambil
      return Center(child: CircularProgressIndicator());
    } else {
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
                    label: Text('Nama Menu'),
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
                    .map(
                      (entry) => DataRow(
                          cells: [
                            DataCell(Text('${entry.key + 1}')),
                            DataCell(Text(entry.value.name)),
                            DataCell(Text(entry.value.price.toString())),
                            DataCell(Text(entry.value.category)),
                            DataCell(IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  // todo hapus data dari database dengan API
                                  MenuService menuService = MenuService();
                                  menuService.deleteMenu(entry.value.id);
                                  // hapus indexnya
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
                                      Nama: entry.value.name,
                                      Kategori: entry.value.category,
                                      Harga: entry.value.price,
                                    )));
                          }),
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
  }

  void _selectTab(String index) {
    if (index == 'home') {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else if (index == 'logout') {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}


