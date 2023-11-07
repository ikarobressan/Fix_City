import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/image_strings.dart';

class ImageWithIcon extends StatelessWidget {
  const ImageWithIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const Image(image: AssetImage(avatarImage)),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: tPrimaryColor,
            ),
            child: const Icon(
              LineAwesomeIcons.alternate_pencil,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
