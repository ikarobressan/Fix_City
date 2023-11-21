import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/colors.dart';
import '../../Controller/theme_controller.dart';
import 'button_loagind_widget.dart';

// Widget personalizado para um botão primário.
class MyPrimaryButton extends StatelessWidget {
  // Construtor que aceita parâmetros para personalizar o botão.
  const MyPrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width = 100.0,
  }) : super(key: key);

  // Texto que será exibido no botão.
  final String text;
  // Ação a ser executada quando o botão for pressionado.
  final VoidCallback onPressed;
  // Indica se o botão está em estado de carregamento.
  final bool isLoading;
  // Determina se o botão deve ocupar a largura total disponível.
  final bool isFullWidth;
  // Define a largura do botão quando `isFullWidth` é `false`.
  final double width;

  // Constrói a interface visual do botão.
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    return SizedBox(
      // Define a largura com base na propriedade `isFullWidth`.
      width: isFullWidth ? double.infinity : width,
      child: ElevatedButton(
        onPressed: onPressed,
        // Exibe um widget de carregamento se `isLoading` for verdadeiro,
        // caso contrário, exibe o texto fornecido.
        child: isLoading
            ? const ButtonLoadingWidget()
            : Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: isDark ? blackColor : whiteColor,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
              ),
      ),
    );
  }
}
