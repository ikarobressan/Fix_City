// Importação dos pacotes necessários.
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../Constants/colors.dart';

// Definição do widget ButtonLoadingWidget.
class ButtonLoadingWidget extends StatelessWidget {
  // Construtor padrão para este widget.
  const ButtonLoadingWidget({ Key? key }) : super(key: key);

  // Método de construção do widget.
  @override
  Widget build(BuildContext context) {
    // Retorna uma linha (Row) contendo um indicador de progresso e um texto.
    return const Row(
      // Alinha os elementos no centro da linha.
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Espaço reservado para o indicador de progresso.
        SizedBox(
          width: 20,
          height: 20,
          // Indicador de progresso circular com cor branca.
          child: CircularProgressIndicator(color: tWhiteColor),
        ),
        // Gap (espaço) de 10 pixels entre o indicador e o texto.
        Gap(10),
        // Texto "Carregando...".
        Text('Carregando...'),
      ],
    );
  }
}
