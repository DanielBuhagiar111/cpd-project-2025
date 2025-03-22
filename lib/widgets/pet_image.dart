import 'dart:io';
import 'package:flutter/material.dart';

class PetImage extends StatelessWidget {
  const PetImage({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 250,
          width: double.infinity,
          color: Colors.black,
          child: Image.file(
            File(imagePath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
