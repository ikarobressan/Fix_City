import 'package:flutter/material.dart';

import '../../Constants/colors.dart';

class ClickableRichTextWidget extends StatelessWidget {
  // Construtor do widget.
  // Ele aceita dois textos (`text1` e `text2`) e uma função de callback (`onPressed`) como parâmetros.
  const ClickableRichTextWidget({
    Key? key,
    required this.text1,
    required this.text2,
    required this.onPressed,
  }) : super(key: key);

  // Declaração das variáveis membro.
  final String text1, text2;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Um GestureDetector é usado para detectar toques.
    return GestureDetector(
      // Função a ser chamada quando o texto é tocado.
      onTap: onPressed,
      child: Padding(
        // Adiciona um preenchimento ao redor do texto.
        padding: const EdgeInsets.all(8),
        child: Text.rich(
          // Exibe um texto combinando múltiplos estilos em sequência.
          TextSpan(
            children: [
              // Primeiro trecho de texto com estilo definido.
              TextSpan(
                text: text1,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              // Segundo trecho de texto com estilo diferente e cor especificada.
              TextSpan(
                text: text2,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: tFacebookBgColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
