import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'Invoice.dart';
import '../models/menu_model.dart';
import '../api/menu_service.dart';
import '../helpers/format_angka.dart';

class NewHome extends StatefulWidget {
  const NewHome({Key? key}) : super(key: key);

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  List<Menu> _menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      MenuService menuService = MenuService();
      List<Menu> menuList = await menuService.getMenu();
      setState(() {
        _menuItems = menuList;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  final Map<Menu, int> _selectedItems = {};

  List<Menu> _filteredMenuItems = [];

  void _resetFilter() {
    setState(() {
      _filteredMenuItems.clear();
      _filteredMenuItems.addAll(_menuItems);
    });
  }

  List<Menu> _searchMenuItems(String query) {
    return _filteredMenuItems
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  int _totalPrice = 0;

  void _addToCart(Menu item) {
    setState(() {
      if (_selectedItems.containsKey(item)) {
        _selectedItems[item] = _selectedItems[item]! + 1;
      } else {
        _selectedItems[item] = 1;
      }
      _totalPrice += item.price;
    });
  }

  void _removeFromCart(Menu item) {
    setState(() {
      if (_selectedItems.containsKey(item)) {
        if (_selectedItems[item] == 1) {
          _selectedItems.remove(item);
        } else {
          _selectedItems[item] = _selectedItems[item]! - 1;
        }
        _totalPrice -= item.price;
      }
    });
  }

  void _navigateToPaymentPage() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentPage(totalPrice: _totalPrice, selectedItems: _selectedItems),
    ),
  );
}

  @override
  Widget build(BuildContext context) {

    if(_menuItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _filteredMenuItems = _searchMenuItems(value);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search Menu',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _resetFilter();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _menuItems.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                Menu item = _menuItems[index];
                int quantity = _selectedItems.containsKey(item)
                    ? _selectedItems[item]!
                    : 0;
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Harga: Rp ${item.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          _removeFromCart(item);
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _addToCart(item);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20.0)
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToPaymentPage,
        label: Text('Total: Rp $_totalPrice'),
        icon: const Icon(Icons.payment),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final int totalPrice;
  final Map<Menu, int> selectedItems;

  PaymentPage({Key? key, required this.totalPrice, required this.selectedItems})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _paymentController = TextEditingController();
  String adminName = 'Administrator'; // Ganti dengan nama admin sesuai kebutuhan
  String dateTime = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()); // Format tanggal + jam sesuai kebutuhan

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }

  Future<void> _submitPayment() async {
    int paymentAmount = int.tryParse(_paymentController.text) ?? 0;
    int changeAmount = paymentAmount - widget.totalPrice;
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
        print('Failed');
      }
    } catch (e) {
      print('Error: $e');
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
                Text('Total Harga', style: const TextStyle(fontSize: 16)),
                Text(formatRupiah(widget.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bayar', style: const TextStyle( fontSize: 16)),
                Container(
                  height: 18,
                  width: 70,
                  child: TextField(
                    controller: _paymentController,
                    keyboardType: TextInputType.number,
                    //decoration: InputDecoration(
                    //  labelText: 'Enter Amount',
                    //  border: OutlineInputBorder(),
                    //),
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