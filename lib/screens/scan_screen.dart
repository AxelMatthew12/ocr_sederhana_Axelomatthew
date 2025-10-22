import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'result_screen.dart';

late List<CameraDescription> cameras;

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  void _initCamera() async {
    try {
      cameras = await availableCameras();
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pemindaian Gagal! Periksa Izin Kamera atau coba lagi.')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<String> _ocrFromFile(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      textRecognizer.close();
      return recognizedText.text;
    } catch (_) {
      return ''; // Kembalikan string kosong jika OCR gagal
    }
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memproses OCR, mohon tunggu...'), duration: Duration(seconds: 2)),
      );

      // Ambil gambar dari kamera
      final XFile image = await _controller!.takePicture();

      // Proses OCR dari gambar
      final ocrText = await _ocrFromFile(File(image.path));

      if (!mounted) return;

      if (ocrText.isEmpty) {
        // Jika teks hasil OCR kosong, tampilkan pesan gagal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pemindaian Gagal! Periksa Izin Kamera atau coba lagi.')),
        );
      } else {
        // Navigasi ke ResultScreen dengan hasil OCR
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(ocrText: ocrText)),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pemindaian Gagal! Periksa Izin Kamera atau coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
              const SizedBox(height: 20),
              Text(
                'Memuat Kamera... Harap tunggu.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pindai')),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                onPressed: _takePicture,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Pindai'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}