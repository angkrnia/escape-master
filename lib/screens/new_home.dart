import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Invoice.dart';

class NewHome extends StatefulWidget {
  const NewHome({Key? key}) : super(key: key);

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  final List<MenuItem> _menuItems = [
    MenuItem(name: 'Nasi Goreng', price: 20000),
    MenuItem(name: 'Mie Goreng', price: 18000),
    MenuItem(name: 'Ayam Bakar', price: 25000),
    MenuItem(name: 'Sate Ayam', price: 15000),
    MenuItem(name: 'Ikan Bakar', price: 22000),
    MenuItem(name: 'Soto Ayam', price: 12000),
    MenuItem(name: 'Bakso', price: 10000),
  ];

  final Map<MenuItem, int> _selectedItems = {};

  List<MenuItem> _filteredMenuItems = [];

  void _resetFilter() {
    setState(() {
      _filteredMenuItems.clear();
      _filteredMenuItems.addAll(_menuItems);
    });
  }

  List<MenuItem> _searchMenuItems(String query) {
    return _filteredMenuItems
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  int _totalPrice = 0;

  void _addToCart(MenuItem item) {
    setState(() {
      if (_selectedItems.containsKey(item)) {
        _selectedItems[item] = _selectedItems[item]! + 1;
      } else {
        _selectedItems[item] = 1;
      }
      _totalPrice += item.price;
    });
  }

  void _removeFromCart(MenuItem item) {
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
  void initState() {
    super.initState();
    _filteredMenuItems.addAll(_menuItems);
  }

  @override
  Widget build(BuildContext context) {
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
              itemCount: _filteredMenuItems.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                MenuItem item = _filteredMenuItems[index];
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

class MenuItem {
  final String name;
  final int price;

  MenuItem({required this.name, required this.price});
}

class PaymentPage extends StatefulWidget {
  final int totalPrice;
  final Map<MenuItem, int> selectedItems;

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
  void _submitPayment() {
    int paymentAmount = int.tryParse(_paymentController.text) ?? 0;
    int changeAmount = paymentAmount - widget.totalPrice;

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
                MenuItem item = widget.selectedItems.keys.elementAt(index);
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
                Text('Rp. ${widget.totalPrice}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                  height: 16,
                  width: 60,
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