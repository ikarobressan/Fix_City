import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/colors.dart';
import '../Constants/image_strings.dart';

class GoogleLoginSignUpWidget extends StatelessWidget {
  // Construtor do widget.
  const GoogleLoginSignUpWidget({
    super.key,
    // Texto que aparecerá no botão.
    required this.text,
    // Ação executada quando o botão for pressionado.
    required this.onPreseed,
  });

  final String text;
  final VoidCallback onPreseed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Widget de texto que exibe "OU".
        Text(
          'OU',
          style: GoogleFonts.inter(
            color: whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        // Espaçamento vertical.
        const Gap(10),
        Padding(
          // Espaçamento horizontal.
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              // Ação quando o botão for pressionado.
              onPressed: onPreseed,
              // Ícone do Google.
              icon: const Image(
                image: AssetImage(googleLogo),
                width: 20,
              ),
              // Texto do botão, definido pelo construtor.
              label: Text(
                text,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Estilização do botão.
              style: ElevatedButton.styleFrom(
                backgroundColor: whiteColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
