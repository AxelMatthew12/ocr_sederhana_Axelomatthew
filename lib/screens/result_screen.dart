import 'package:flutter/material.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final String ocrText;
  const ResultScreen({super.key, required this.ocrText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil OCR')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            ocrText, // Menampilkan teks asli tanpa replaceAll sehingga \n dipertahankan
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}