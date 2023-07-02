class User {
  final int id;
  final String username;
  final String fullname;

  User({required this.id, required this.username, required this.fullname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      fullname: json['fullname'],
    );
  }
}
