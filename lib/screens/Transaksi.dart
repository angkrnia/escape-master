// ignore_for_file: file_names

import 'package:escape/models/TransaksiModel.dart';
import 'package:flutter/material.dart';
import '../models/TransaksiModel.dart';
import '../models/TransaksiBarangModel.dart';
import 'Invoice.dart';
import 'new_home.dart';
import '../models/menu_model.dart';
import '../api/menu_service.dart';
import 'package:http/http.dart' as http;
import '../helpers/format_angka.dart';
import 'dart:convert';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  List<Map<String, dynamic>> _daftarTransaksi = [];
  List<Map<String, dynamic>> _listBarang = [];

  Future<void> getOrders() async {
    final uri = Uri.parse('https://calm-red-dove-fez.cyclic.app/orders');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final result = jsonResponse['data']['orders'];
        print(result);
        if (result != null) {
          setState(() {
            _daftarTransaksi = List<Map<String, dynamic>>.from(result);
          });
        } else {
          throw Exception("API response does not contain 'orders' data");
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    if (_daftarTransaksi.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Transaksi"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  showCheckboxColumn: false,
                  columnSpacing: 16.0,
                  columns: const [
                    DataColumn(
                      label: Text('Invoice No'),
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
                  rows: _daftarTransaksi.map<DataRow>(
                    (entry) {
                      final dateTime = DateTime.parse(entry['order_date']);
                      final formattedDate =
                          '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
                      return DataRow(
                        cells: [
                          DataCell(Text(entry['id'].toString())),
                          DataCell(Text(entry['created_by'].toString())),
                          DataCell(Text(formattedDate)),
                          DataCell(Text(formatRupiah(entry['total_price']))),
                          DataCell(Text(formatRupiah(entry['total_payment']))),
                          DataCell(Text(
                              (entry['total_payment'] - entry['total_price'])
                                  .toString())),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _daftarTransaksi.remove(entry);
                                });
                              },
                            ),
                          ),
                        ],
                        onSelectChanged: (selected) {
                          String namaKasir = entry['kasir'].toString();
                          String time = entry['jam'].toString();
                          int totalPrice = entry['total'];
                          int paymentAmount = entry['bayar'];
                          int changeAmount = paymentAmount - totalPrice;
                          Menu menuItem = Menu(
                            name: 'Nasi Goreng',
                            price: 20000,
                            category: 'Makanan',
                            id: 1,
                          );
                          Map<Menu, int> selectedItems = {menuItem: 1};

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvoicePage(
                                namaKasir: namaKasir,
                                time: time,
                                totalPrice: totalPrice,
                                paymentAmount: paymentAmount,
                                changeAmount: changeAmount,
                                selectedItems: selectedItems,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              ),
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
          Navigator.pushNamed(context, '/home2');
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


