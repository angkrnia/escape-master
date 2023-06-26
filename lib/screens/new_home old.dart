import 'package:flutter/material.dart';

class NewHome extends StatefulWidget {
  const NewHome({super.key});

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
          builder: (context) => PaymentPage(totalPrice: _totalPrice)),
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
            child: ListView.builder(
              itemCount: _filteredMenuItems.length,
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

class PaymentPage extends StatelessWidget {
  final int totalPrice;

  const PaymentPage({Key? key, required this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Text('Total Price: \$ $totalPrice'),
      ),
    );
  }
}
