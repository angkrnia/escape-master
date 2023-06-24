class Menu {
  final int id;
  final String name;
  final int price;
  final String category;

  Menu({required this.name, required this.price, required this.category, required this.id});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        category: json['category']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'category': category
    };
  }

  @override
  String toString() {
    return 'Menu{name: $name, price: $price, category: $category}';
  }
}
