import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputDescription extends StatelessWidget {
  
  // Construtor que inicializa o widget com um `TextEditingController`.
  const InputDescription({
    super.key,
    required this.description,
  });

  // Controlador para o campo de texto onde o usuário inserirá a descrição.
  final TextEditingController description;

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
              'Descrição',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        
        // Espaçamento vertical.
        const Gap(6),
        
        // Campo de entrada personalizado para inserção da descrição.
        InputTextField(
          // Passando o controlador para o widget.
          controller: description,
          // Define o tipo de teclado como texto.
          keyBoardType: TextInputType.text,
          // Placeholder para o campo de entrada, indicando ao usuário o que é esperado.
          hintText: 'Descrição do incidente',
          // Permite a entrada de múltiplas linhas (até 5 linhas).
          maxLines: 5,
          // Define o comprimento máximo de texto permitido (500 caracteres).
          maxLength: 500,
          // Não oculta o texto.
          obscureText: false,
          // Função para validar a entrada. Retorna uma mensagem de erro se o valor for em branco.
          onValidator: (value) {
            return value.isBlank ? 'Insira uma descrição' : null;
          },
        ),
      ],
    );
  }
}
