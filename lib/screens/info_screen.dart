import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Informasi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tugas Project Mobile Programming",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "KELOMPOK 6",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text("Angga Kurnia - 201011401198"),
            Text("Anjas Kosasih - 201011401086"),
            Text("Raden Azka Hermanto - 201011401740"),
            Text("Stevianus Imanuel Salangka - 201011401550"),
            Text("Unggul Prasetyo Utomo - 201011401212"),
          ],
        ),
      ),
    );
  }
}