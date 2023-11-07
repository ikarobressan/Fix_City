import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_safe_city/src/Constants/colors.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.canPop(Get.context!)) {
          Get.back();
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: Image.network(imageUrl),
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
      ),
    );
  }
}
