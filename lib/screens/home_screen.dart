import 'package:flutter/material.dart';
import 'scan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.blue),
            title: const Text('Mulai Pindai Teks Baru'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScanScreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}
