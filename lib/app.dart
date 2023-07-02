// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/settings.dart';
import 'screens/info_screen.dart';
import 'screens/menu/menu_screen.dart';
import 'screens/laporan/laporan_screen.dart';
import 'screens/transaksi/transaksi.dart';
import 'screens/users/user_screen.dart';
import 'screens/users/user_form.dart';
import 'screens/order/form_order.dart';
import 'screens/category/new_category.dart';
import 'screens/menu/menu_form.dart';
import 'screens/category/category_screen.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kantin Ashima',
      initialRoute: '/home',
      home: const HomeScreen(title: 'Kantin Ashima'),
      routes: {
        '/home2': (context) => const NewHome(),
        '/home': (context) => const HomeScreen(title: 'Kantin Ashima'),
        '/barang': (context) => const MenuScreen(),
        '/laporan': (context) => const LaporanScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/login': (context) => const Login(),
        '/transaksi': (context) => const TransaksiScreen(),
        '/user': (context) => const UserScreen(),
        '/barangform': (context) => const BarangForm(),
        '/userform': (context) => const UserForm(),
        '/category': (context) => const CategoryScreen(),
        '/info': (context) => const InfoScreen(),
        '/new_category': (context) => const NewCategory(),
      },
    );
  }
}
