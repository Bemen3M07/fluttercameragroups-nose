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

  // SOLUCIÓ 1: Canviem de 'File?' a 'List<File>' per guardar moltes fotos
  final List<File> _gallery = [];

  // La funció ara AFEGEIX a la llista, no sobreescriu
  void _updateImage(File image) {
    setState(() {
      _gallery.add(image);
    });
  }

  static const List<String> _titles = ['Càmera', 'Galeria', 'Multimèdia'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CameraScreen(onImageCaptured: _updateImage),
      // Passem la LLISTA sencera a la pantalla de galeria
      PhotoScreen(galleryImages: _gallery),
      const AudioScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Càmera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Galeria',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Multimèdia',
          ),
        ],
      ),
    );
  }
}
