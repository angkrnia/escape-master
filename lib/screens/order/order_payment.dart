// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../models/menu_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../invoice/invoice.dart';
import '../../helpers/format_angka.dart';

class PaymentPage extends StatefulWidget {
  final int totalPrice;
  final Map<Menu, int> selectedItems;

  const PaymentPage({Key? key, required this.totalPrice, required this.selectedItems})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _paymentController = TextEditingController();
  String adminName = 'Administrator';
  String dateTime = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }

  Future<void> _submitPayment() async {
    int paymentAmount = int.tryParse(_paymentController.text) ?? 0;
    int changeAmount = paymentAmount - widget.totalPrice;

    if(paymentAmount < widget.totalPrice) {
      Fluttertoast.showToast(
          msg: "Jumlah pembayaran kurang",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red[900],
          textColor: Colors.white);
      return;
    }

    try {
      final uri = Uri.parse('https://calm-red-dove-fez.cyclic.app/orders');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'total_price': widget.totalPrice,
        'total_payment': paymentAmount,
        'menu': widget.selectedItems.keys
            .map((item) =>
                {'menu_id': item.id, 'quantity': widget.selectedItems[item]})
            .toList(),
      };
      final response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: "Order berhasil ditambahkan",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        Fluttertoast.showToast(
            msg: "Order gagal ditambahkan",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red[900],
            textColor: Colors.white);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Order gagal ditambahkan",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red[900],
          textColor: Colors.white);
      print('Error: $e');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoicePage(
          namaKasir: adminName,
          time: dateTime,
          totalPrice: widget.totalPrice,
          paymentAmount: paymentAmount,
          changeAmount: changeAmount,
          selectedItems: widget.selectedItems,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(adminName),
                Text(dateTime),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.selectedItems.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                Menu item = widget.selectedItems.keys.elementAt(index);
                int quantity = widget.selectedItems.values.elementAt(index);
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
                const Text('Total Harga', style: TextStyle(fontSize: 16)),
                Text(formatRupiah(widget.totalPrice),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Bayar', style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 18,
                  width: 70,
                  child: TextField(
                    controller: _paymentController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Center(
            child: ElevatedButton(
              onPressed: _submitPayment,
              child: const Text('Submit'),
            ),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}
