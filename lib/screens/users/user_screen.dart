import './user_detail.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<User> _daftarUser = [];

  Future<void> fetchUser() async {
    try {
      final uri = Uri.parse('https://calm-red-dove-fez.cyclic.app/users');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final result = jsonResponse['data']['users'];
        // print(result);
        if (result != null) {
          setState(() {
            _daftarUser = List<User>.from(result.map((x) => User.fromJson(x)));
          });
        } else {
          throw Exception("API response does not contain 'users' data");
        }
      }
    } catch (e) {
      print('Error fetching data users: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_daftarUser.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar User"),
      ),
      body: ListView.builder(
        itemCount: _daftarUser.length,
        itemBuilder: (context, index) {
          final user = _daftarUser[index];

          return Card(
            child: ListTile(
              title: Text(user.fullname),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: ${user.username}'),
                  const SizedBox(width: 16),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(user.id, index);
                },
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UserDetail(
                      id: user.id,
                      fullname: user.fullname,
                      username: user.username,
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

  void _showDeleteConfirmationDialog(int id, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Penghapusan'),
          content: Text('Anda yakin ingin menghapus user ini?'),
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
                deleteUser(id, index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUser(int id, int index) async {
    try {
      final uri = Uri.parse('https://calm-red-dove-fez.cyclic.app/users/$id');
      final response = await http.delete(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final result = jsonResponse['status'];
        if (result != "fail") {
          Fluttertoast.showToast(
            msg: "User berhasil dihapus",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
          );
          setState(() {
            _daftarUser.removeAt(index);
          });
        } else {
          Fluttertoast.showToast(
            msg: "User gagal dihapus",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: const Color.fromARGB(255, 215, 3, 3),
          );
          throw Exception("API response does not contain 'message' data");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "User gagal dihapus",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 215, 3, 3),
      );
      print('Error deleting user: $e');
    }
  }
}
