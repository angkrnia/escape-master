import 'package:flutter/material.dart';
import '../../models/menu_model.dart';
import '../../api/menu_service.dart';
import 'order_payment.dart';

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

