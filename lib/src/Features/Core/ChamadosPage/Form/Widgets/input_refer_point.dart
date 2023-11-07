import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputReferPoint extends StatelessWidget {
  
  // Construtor que inicializa o widget com um `TextEditingController`.
  const InputReferPoint({
    super.key,
    required this.referPoint,
  });

  // Controlador para o campo de texto onde o usuário inserirá o ponto de referência.
  final TextEditingController referPoint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        // Espaçamento vertical.
        const Gap(12),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título do campo de entrada.
            Text(
              'Ponto de Referência *',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        
        // Espaçamento vertical.
        const Gap(6),
        
        // Campo de entrada personalizado para inserção do ponto de referência.
        InputTextField(
          // Passando o controlador para o widget.
          controller: referPoint,
          // Define o tipo de teclado como texto.
          keyBoardType: TextInputType.text,
          // Placeholder para o campo de entrada, indicando ao usuário o que é esperado.
          hintText: 'Ajude-nos a te encontrar',
          // Limita a entrada a uma única linha.
          maxLines: 1,
          // Não oculta o texto.
          obscureText: false,
          // Função para validar a entrada. Retorna uma mensagem de erro se o valor for em branco.
          onValidator: (value) {
            return value.isBlank ? 'Insira um ponto de Referência' : null;
          },
        ),
      ],
    );
  }
}
