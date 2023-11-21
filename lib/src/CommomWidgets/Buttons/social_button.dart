import 'package:flutter/material.dart';

import '../../Constants/colors.dart';
import 'button_loagind_widget.dart';

// Widget personalizado para um botão de mídia social.
class SocialButton extends StatelessWidget {
  // Construtor que aceita parâmetros para personalizar o botão.
  const SocialButton({
    Key? key,
    required this.text,
    required this.image,
    this.isLoading = false,
    required this.background,
    required this.onPressed,
    required this.foreground,
  }) : super(key: key);

  // Texto que será exibido no botão.
  final String text;
  // Caminho para a imagem ou ícone da mídia social.
  final String image;
  // Cores do botão.
  final Color foreground, background;
  // Ação a ser executada quando o botão for pressionado.
  final VoidCallback onPressed;
  // Indica se o botão está em estado de carregamento.
  final bool isLoading;

  // Constrói a interface visual do botão.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: foreground,
          backgroundColor: background,
          side: BorderSide.none,
        ),
        // Exibe uma caixa vazia se `isLoading` for verdadeiro,
        // caso contrário, exibe a imagem fornecida.
        icon: isLoading
            ? const SizedBox()
            : Image(
                image: AssetImage(image),
                width: 24,
                height: 24,
              ),
        // Exibe um widget de carregamento se `isLoading` for verdadeiro,
        // caso contrário, exibe o texto fornecido.
        label: isLoading
            ? const ButtonLoadingWidget()
            : Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: blackColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
      ),
    );
  }
}
