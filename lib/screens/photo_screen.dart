import 'dart:io';
import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  final File? image;

  const PhotoScreen({super.key, this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: image == null
          ? const Text('Fes una foto primer!')
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Última captura:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Image.file(image!, height: 400),
              ],
            ),
    );
  }
}
