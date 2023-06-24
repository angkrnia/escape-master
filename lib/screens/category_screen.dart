import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../api/category_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // List<String> _categories = [
  //   'Makanan Pembuka',
  //   'Makanan Utama',
  //   'Makanan Penutup',
  //   'Minuman',
  // ];
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      CategoryService categoryService = CategoryService();
      List<Category> categoryList = await categoryService.getMenu();
      setState(() {
        _categories = categoryList;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) {
      // Tampilkan widget atau indikator loading saat data masih diambil
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategori Makanan"),
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
                  label: Text('Nama'),
                ),
                DataColumn(
                  label: Text('Aksi'),
                ),
              ],
              rows: _categories
                  .asMap()
                  .entries
                  .map((entry) => DataRow(
                      cells: [
                        DataCell(Text('${entry.key + 1}')),
                        DataCell(Text(entry.value.name)),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _categories.removeAt(entry.key);
                            });
                          },
                        )),
                      ],
                      // onSelectChanged: (selected) {
                      //   // insert your navigation function here and use the selected value returned by the function
                      //   //Navigator.pushNamed(context, '/home');
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => UserDetail(
                      //     id: entry.value.id,
                      //     nama: entry.value.name,
                      //     )));
                      // }
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
          Navigator.pushNamed(context, '/');
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