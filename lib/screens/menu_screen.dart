// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import '../models/menu_model.dart';
import '../models/category_model.dart';
import '../api/menu_service.dart';
import '../api/category_service.dart';
import '../helpers/format_angka.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  List<Menu> _daftarMenu = [];
  final List<Category> _categories = [];
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    fetchDataMenu();
    fetchDataCategories();
  }

  Future<void> fetchDataMenu() async {
    try {
      MenuService menuService = MenuService();
      List<Menu> menuList = await menuService.getMenu();
      setState(() {
        _daftarMenu = menuList;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchDataCategories() async {
    try {
      CategoryService categoryService = CategoryService();
      List<Category> categoryList = await categoryService.getMenu();
      setState(() {
        _categories.addAll(categoryList);
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _showDeleteConfirmationDialog(int id) {
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
                // Tambahkan logika penghapusan item di sini
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_daftarMenu.isEmpty) {
      // Tampilkan widget atau indikator loading saat data masih diambil
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Menu Makanan"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = _categories[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(category.name),
                          selected: _selectedCategory == category.name,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedCategory = selected ? category.name : '';
                            });
                          },
                          selectedColor: Colors.blue,
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _daftarMenu.length,
                itemBuilder: (BuildContext context, int index) {
                  final menu = _daftarMenu[index];

                  if (_selectedCategory.isNotEmpty &&
                      menu.category != _selectedCategory) {
                    return const SizedBox.shrink();
                  }

                  return InkWell(
                    onTap: () {
                      // todo
                    },
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              leading: const Icon(Icons.restaurant_menu),
                              title: Text(menu.name),
                              subtitle: Text(
                                  '${menu.category} - ${formatRupiah(menu.price)}'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteConfirmationDialog(menu.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
