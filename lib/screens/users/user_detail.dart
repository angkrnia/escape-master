import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  final int? id;
  final String? fullname;
  final String? username;

  const UserDetail({
    Key? key,
    this.id,
    this.fullname,
    this.username,
  }) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail User'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text("Id User : ${widget.id}"),
            Text("Fullname : ${widget.fullname}"),
            Text("Username : ${widget.username}")
          ],
        ),
      ),
    );
  }
}
