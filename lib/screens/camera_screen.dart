import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gal/gal.dart';
import '../main.dart';

class CameraScreen extends StatefulWidget {
  final Function(File) onImageCaptured;

  const CameraScreen({super.key, required this.onImageCaptured});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isFlashOn = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera(_selectedCameraIndex);
  }

  // Mètode per inicialitzar o canviar la càmera
  Future<void> _initCamera(int index) async {
    if (cameras.isEmpty) return;

    // Si ja hi havia un controlador, l'eliminem abans de crear-ne un de nou
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      cameras[index],
      ResolutionPreset.medium,
      enableAudio: false, // Millora el rendiment si només volem fotos
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("Error inicialitzant la càmara: $e");
    }
  }

  // FUNCIONALITAT: Canviar Flash
  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    await _controller!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  // FUNCIONALITAT: Canviar entre càmera frontal i trasera
  void _switchCamera() {
    if (cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex == 0) ? 1 : 0;
    _initCamera(_selectedCameraIndex);
  }

  // FUNCIONALITAT: Capturar foto i mostrar Alert
  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile image = await _controller!.takePicture();

      // --- LÒGICA EXERCICI 2: GUARDAR A LA GALERIA ---
      // Guardem la imatge a la galeria del telèfon
      await Gal.putImage(image.path);
      // ----------------------------------------------

      final File file = File(image.path);
      widget.onImageCaptured(file);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Guardat permanent'),
            content:
                Text('La foto s\'ha desat a la Galeria i a:\n${image.path}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Perfecte'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error desant la foto: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameras.isEmpty) return const Center(child: Text('No hi ha càmeres'));
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // 1. El Preview de la càmera ocupa tota la pantalla
        Positioned.fill(
          child: CameraPreview(_controller!),
        ),

        // 2. El Menú Diferenciat (com demana l'enunciat)
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botó Flash
                IconButton(
                  icon: Icon(
                    _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    color: _isFlashOn ? Colors.yellow : Colors.white,
                  ),
                  onPressed: _toggleFlash,
                ),
                // Botó Captura (més gran)
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 40),
                  ),
                ),
                // Botó Canvi Càmera
                IconButton(
                  icon: const Icon(Icons.cameraswitch, color: Colors.white),
                  onPressed: _switchCamera,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
