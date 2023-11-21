import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../Constants/colors.dart';

class FullScreenImage extends StatelessWidget {
  final String? imageUrl;
  final String? imagePath;

  const FullScreenImage({super.key, this.imageUrl, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (imageUrl != null)
            Center(
              child: Image.network(imageUrl!),
            ),
          if (imagePath != null)
            Center(
              child: Image.file(File(imagePath!)),
            ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              iconSize: 35,
              icon: const Icon(Icons.arrow_back, color: whiteColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
