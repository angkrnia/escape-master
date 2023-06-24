class Category {
  int id;
  String name;

  Category({required this.name, required this.id});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name']
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id};
  }
}