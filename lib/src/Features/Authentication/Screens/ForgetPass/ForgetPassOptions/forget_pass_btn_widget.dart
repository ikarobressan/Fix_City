// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../Constants/colors.dart';
import '../../../../../Controller/theme_controller.dart';

/// [FgtPassBtnWidget] é um widget personalizado que representa
/// um botão para a opção de redefinição de senha.
class FgtPassBtnWidget extends StatelessWidget {
  // Construtor do widget
  const FgtPassBtnWidget({
    super.key,
    required this.btnIcon,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  final IconData btnIcon; // Ícone do botão
  final String title, subTitle; // Título e subtítulo do botão
  final VoidCallback onTap; // Ação ao pressionar o botão

  @override
  Widget build(BuildContext context) {
    // Controlador de tema para verificar o modo escuro
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return GestureDetector(
      onTap: onTap, // Ação ao tocar
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // Cor de fundo com base no tema
          color: isDark ? tDarkCard : Colors.grey.shade200,
        ),
        child: Row(
          children: [
            // Ícone
            Icon(
              btnIcon,
              size: 50,
            ),
            Gap(5),
            // Descrição do botão
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  subTitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
