// ignore_for_file: file_names
import 'package:escape/screens/User_detail.dart';
import 'package:flutter/material.dart';
import '../models/UserModel.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final List<User> _daftarUser = [
    User(id: 'admin', nama: 'Administrator', alamat: 'admin'),
    User(id: 'unggul', nama: 'Unggul P', alamat: 'tangsel'),
    User(id: 'angga', nama: 'Angga K', alamat: 'cisoka'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar User"),
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
                  label: Text('User ID'),
                ),
                DataColumn(
                  label: Text('Nama'),
                ),
                DataColumn(
                  label: Text('Alamat'),
                ),
                DataColumn(
                  label: Text('Aksi'),
                ),
              ],
              rows: _daftarUser
                  .asMap()
                  .entries
                  .map((entry) => DataRow(
                      cells: [
                        DataCell(Text('${entry.key + 1}')),
                        DataCell(Text(entry.value.id)),
                        DataCell(Text(entry.value.nama)),
                        DataCell(Text(entry.value.alamat)),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _daftarUser.removeAt(entry.key);
                            });
                          },
                        )),
                      ],
                      onSelectChanged: (selected) {
                        // insert your navigation function here and use the selected value returned by the function
                        //Navigator.pushNamed(context, '/home');
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserDetail(
                          id: entry.value.id,
                          nama: entry.value.nama,
                          alamat: entry.value.alamat,
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
          Navigator.pushNamed(context, '/userform');
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
