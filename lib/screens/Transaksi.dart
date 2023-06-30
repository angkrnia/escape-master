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
      body: ListView.builder(
        itemCount: _daftarTransaksi.length,
        itemBuilder: (context, index) {
          final entry = _daftarTransaksi[index];
          final dateTime = DateTime.parse(entry['order_date']);
          final formattedDate =
              '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';

          return Card(
            child: ListTile(
              title: Text('${entry['id']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kasir: ${entry['created_by']}'),
                  Text('Jam Transaksi: $formattedDate'),
                  Text('Total Harga: ${formatRupiah(entry['total_price'])}'),
                  //Text('Bayar: ${formatRupiah(entry['total_payment'])}'),
                  //Text('Kembali: ${entry['total_payment'] - entry['total_price']}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _daftarTransaksi.removeAt(index);
                  });
                },
              ),
              onTap: () {
                String namaKasir = entry['created_by'].toString();
                String time = formattedDate;
                int totalPrice = entry['total_price'];
                int paymentAmount = entry['total_payment'];
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
            ),
          );
        },
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


