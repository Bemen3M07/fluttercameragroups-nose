import 'dart:io';
import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  final List<File> galleryImages;

  const PhotoScreen({super.key, required this.galleryImages});

  @override
  Widget build(BuildContext context) {
    if (galleryImages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 10),
            Text("Encara no has fet cap foto."),
          ],
        ),
      );
    }

    // 1. Invertimos la lista aquí para que la lógica sea más fácil.
    // Así la posición 0 es la foto más reciente tanto en la Grid como en el Slider.
    final List<File> reversedImages = galleryImages.reversed.toList();

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: reversedImages.length,
      itemBuilder: (context, index) {
        final imageFile = reversedImages[index];

        return GestureDetector(
          onTap: () {
            // 2. Al tocar, pasamos LA LISTA ENTERA y el ÍNDICE actual
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenGallery(
                  images: reversedImages,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: Hero(
            tag: imageFile.path,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- NUEVA CLASE: GALERÍA DESLIZABLE ---
class FullScreenGallery extends StatefulWidget {
  final List<File> images;
  final int initialIndex;

  const FullScreenGallery({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Iniciamos el controlador en la foto que hemos tocado
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        // Mostramos "Foto X de Y" en el título
        title: Text(
          "${_currentIndex + 1} de ${widget.images.length}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      // 3. PageView permite deslizar izquierda/derecha
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final imageFile = widget.images[index];

          // Mantenemos el InteractiveViewer para poder hacer ZOOM
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Hero(
                tag: imageFile.path,
                child: Image.file(imageFile),
              ),
            ),
          );
        },
      ),
    );
  }
}
