// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/format_angka.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final url = 'https://calm-red-dove-fez.cyclic.app/info/saldo-today';
  int saldo = 0;

  Future<void> getSaldo() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // print(response.body);
        final js = json.decode(response.body);
        final result = js['data']['saldo_today'] ?? 0;
        if (result != null) {
          setState(() {
            saldo = int.tryParse(result.toString()) ?? 0;
          });
        } else {
          throw Exception("API response does not contain 'saldo' data");
        }
      } else {
        throw Exception(
            "Error hit API status code not 200: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error hit API: ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    getSaldo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: getSaldo,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 14.0),
              const Text(
                'Selamat Datang Administrator',
                style: TextStyle(
                  fontSize: 14.0,
                  // fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.all(10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Transaksi Hari Ini',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),),
                      const SizedBox(height: 8),
                    Text(formatRupiah(saldo),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                      ),),
                      const SizedBox(height: 8),
                  ],
                  
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                decoration: const BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage("images/bg.png"),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (3 / 1.5),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    menuItem(Icons.shopping_cart, 'Transaksi', '/transaksi'),
                    menuItem(Icons.restaurant_menu, 'Menu', '/barang'),
                    menuItem(Icons.category, 'Kategori', '/category'),
                    menuItem(Icons.person, 'User', '/user'),
                    menuItem(Icons.calendar_month, 'Laporan', '/laporan'),
                    menuItem(Icons.info, 'Info', '/info'),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                _selectTab('home');
              },
            ),
            const SizedBox(width: 40), // Mengatur jarak antara menu utama
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
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
      getSaldo();
    } else if (index == 'logout') {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Widget menuItem(IconData icon, String title, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon),
            const SizedBox(height: 8),
            Text(" "),
            Text(title),
          ],
        ),
      ),
    );
  }
}
