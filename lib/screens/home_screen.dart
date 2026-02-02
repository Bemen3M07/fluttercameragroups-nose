import 'dart:io';
import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'photo_screen.dart';
import 'audio_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  File? _lastImage; // Variable d'estat per guardar la foto

  // Funció que passarem a la CameraScreen per rebre la foto
  void _updateImage(File image) {
    setState(() {
      _lastImage = image;
    });
  }

  static const List<String> _titles = ['Càmara', 'Foto', 'Multimèdia'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Definim les pantalles aquí per passar els paràmetres necessaris
    final List<Widget> pages = [
      CameraScreen(onImageCaptured: _updateImage), // Passem la funció callback
      PhotoScreen(image: _lastImage), // Passem la imatge
      const AudioScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt), label: 'Càmara'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Foto'),
          BottomNavigationBarItem(
              icon: Icon(Icons.audiotrack), label: 'Música'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
