// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../invoice/invoice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/menu_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../helpers/format_angka.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  List<Map<String, dynamic>> _daftarTransaksi = [];

  Future<void> getOrders() async {
    try {
      final uri = Uri.parse('https://calm-red-dove-fez.cyclic.app/orders');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final result = jsonResponse['data']['orders'];
        // print(result);
        if (result != null) {
          setState(() {
            _daftarTransaksi = List<Map<String, dynamic>>.from(result);
          });
        } else {
          throw Exception("API response does not contain 'orders' data");
        }
      }
    } catch (e) {
      print('Error fetching data orders: $e');
    }
  }

  void _showDeleteConfirmationDialog(String id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Penghapusan'),
          content: Text('Anda yakin ingin menghapus item ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                deleteTransaksi(id, index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteTransaksi(String id, int index) async {
    final uri = Uri.parse('https://calm-red-dove-fez.cyclic.app/orders/$id');
    try {
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final result = jsonResponse['status'];
        if (result == 'success') {
          Fluttertoast.showToast(
              msg: "Order berhasil dihapus.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.green,
              textColor: Colors.white);
          setState(() {
            _daftarTransaksi.removeAt(index);
          });
        } else {
          throw Exception("API response does not contain 'orders' data");
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<dynamic> getDetailOrderById(String id) async {
    final uri = Uri.parse('https://calm-red-dove-fez.cyclic.app/orders/$id');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final result = jsonResponse['data'];
        if (result != null) {
          return result;
        } else {
          throw Exception("API response does not contain 'order' data");
        }
      }
    } catch (e) {
      print('Error fetching data transaksi: $e');
    }
    return null;
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
          final dateTime = DateTime.parse(entry['order_date']).toUtc();
          final gmtDateTime = dateTime.add(const Duration(hours: 7));
          final formattedDate = gmtDateTime.toString();

          return Card(
            child: ListTile(
              title: Text('${entry['id']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kasir: ${entry['created_by']}'),
                  Text('Jam Transaksi: $formattedDate'),
                  Text('Total Harga: ${formatRupiah(entry['total_price'])}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(entry['id'], index);
                },
              ),
              onTap: () {
                var detailOrder = getDetailOrderById(entry['id']);
                detailOrder.then((value) {
                  String namaKasir = value['cashier'];
                  String time = value['order_date'];
                  int totalPrice = value['total_price'];
                  int paymentAmount = value['total_payment'];
                  int changeAmount = paymentAmount - totalPrice;
                  List<dynamic> selectedItems = value['menu'];
                  Map<Menu, int> convertedItems = {};
                  for (dynamic item in selectedItems) {
                    Menu menu = Menu(
                      id: item['menu_id'],
                      name: item['name'],
                      price: item['total_price'],
                      category: item['category'],
                    );
                    convertedItems[menu] = convertedItems.containsKey(menu)
                        ? convertedItems[menu]! + 1
                        : 1;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvoicePage(
                        namaKasir: namaKasir,
                        time: time,
                        totalPrice: totalPrice,
                        paymentAmount: paymentAmount,
                        changeAmount: changeAmount,
                        selectedItems: convertedItems,
                      ),
                    ),
                  );
                });
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


