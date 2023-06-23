// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: GridView.count(
            crossAxisCount: 2,
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
          Navigator.pushNamed(context, '/create');
        },
      ),
    );
  }

  void _selectTab(String index) {
    if (index == 'home') {
      //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
