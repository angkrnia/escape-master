// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../models/menu_model.dart';

class InvoicePage extends StatelessWidget {
  final String namaKasir;
  final String time;
  final int totalPrice;
  final int paymentAmount;
  final int changeAmount;
  final Map<Menu, int> selectedItems;

  const InvoicePage({
    Key? key,
    required this.namaKasir,
    required this.time,
    required this.totalPrice,
    required this.paymentAmount,
    required this.changeAmount,
    required this.selectedItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(namaKasir),
                Text(time),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: selectedItems.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                Menu item = selectedItems.keys.elementAt(index);
                int quantity = selectedItems.values.elementAt(index);
                int subtotal = item.price * quantity;

                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Qty: $quantity'),
                  trailing: Text('Rp. $subtotal'),
                );
              },
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Harga', style: const TextStyle( fontSize: 16)),
                Text('Rp. $totalPrice', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jumlah Bayar', style: const TextStyle( fontSize: 16)),
                Text('Rp. $paymentAmount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kembalian', style: const TextStyle( fontSize: 16)),
                Text('Rp. $changeAmount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
              child: const Text('Home'),
            ),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}

