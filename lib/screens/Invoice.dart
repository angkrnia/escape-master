// ignore_for_file: file_names

import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan argumen dari ModalRoute
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      final String namaPembeli = arguments['namaPembeli'] as String;
      final String jam = arguments['jam'] as String;
      final int totalHarga = arguments['totalHarga'] as int;
      final int bayar = arguments['bayar'] as int;
      final int kembali = bayar - totalHarga;
      final List<dynamic> listBarang = arguments['listBarang'] as List<dynamic>;
      print(listBarang);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Invoice'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kasir: $namaPembeli'),
            Text('Jam Transaksi: $jam'),
            Text('\n'),
            const Text('Daftar Barang:'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listBarang.length,
              itemBuilder: (context, index) {
                final dynamic barang = listBarang[index];
                return ListTile(
                  title: Text(barang['nama']),
                  subtitle: Text('Harga: ${barang['harga']}'),
                );
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Total Pembayaran: $totalHarga',
                    style:
                        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Total Bayar: $bayar',
                    style:
                        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Kembali: $kembali',
                    style:
                        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Jika argumen tidak ada atau tidak sesuai format, tampilkan halaman kosong
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: const Center(
        child: Text('Tidak Ada Data.'),
      ),
    );
  }
}
