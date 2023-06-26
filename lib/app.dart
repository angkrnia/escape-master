// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'screens/Home.dart';
import 'screens/menu_screen.dart';
import 'screens/Laporan.dart';
import 'screens/Settings.dart';
import 'screens/FormTambah.dart';
import 'screens/Invoice.dart';
import 'screens/login.dart';
import 'screens/Transaksi.dart';
import 'screens/User.dart';
import 'screens/Barang_form.dart';
import 'screens/User_form.dart';
import 'screens/category_screen.dart';
import 'screens/info_screen.dart';
import 'screens/new_home.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kantin Ashima',
      initialRoute: '/home',
      // home: const NewHome(),
      home: const HomeScreen(title: 'Kantin Ashima'),
      routes: {
        '/home2': (context) => const NewHome(),
        '/home': (context) => const HomeScreen(title: 'Kantin Ashima'),
        '/barang': (context) => const MenuScreen(),
        '/laporan': (context) => const LaporanScreen(),
        '/settings': (context) => const SettingsScreen(),
        // '/create': (context) => const PenjualanForm(),
        //'/invoice': (context) => const InvoiceScreen(),
        '/login': (context) => const Login(),
        '/transaksi': (context) => const TransaksiScreen(),
        '/user': (context) => const UserScreen(),
        '/barangform': (context) => const BarangForm(),
        '/userform': (context) => const UserForm(),
        '/category': (context) => const CategoryScreen(),
        '/info': (context) => const InfoScreen(),
      },
    );
  }
}
