import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final String ocrText;
  const ResultScreen({super.key, required this.ocrText});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late FlutterTts _flutterTts;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();

    // Atur bahasa pembacaan menjadi Bahasa Indonesia
    _flutterTts.setLanguage("id-ID");
  }

  @override
  void dispose() {
    // Hentikan mesin TTS saat halaman ditutup
    _flutterTts.stop();
    super.dispose();
  }

  // Fungsi untuk membacakan teks menggunakan FlutterTts
  void _speak() async {
    if (!mounted) return; // Pastikan widget masih terpasang sebelum memulai TTS
    await _flutterTts.speak(widget.ocrText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil OCR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: 'Bacakan Teks',
            onPressed: _speak, // Memanggil fungsi untuk membacakan teks
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            widget.ocrText, // Menampilkan teks asli tanpa replaceAll sehingga \n dipertahankan
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!mounted) return; // Pastikan widget masih terpasang sebelum navigasi
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        },
        tooltip: 'Kembali ke Beranda',
        child: const Icon(Icons.home),
      ),
    );
  }
}