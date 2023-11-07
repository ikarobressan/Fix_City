import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputAdminMessage extends StatelessWidget {
  // Construtor que inicializa o widget com um `TextEditingController`.
  const InputAdminMessage({super.key, required this.adminMessage});

  // Controlador para o campo de texto onde o administrador inserirá sua mensagem.
  final TextEditingController adminMessage;

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
              'Mensagem para o usuário',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),

        // Espaçamento vertical.
        const Gap(6),

        // Campo de entrada personalizado.
        InputTextField(
          // Passando o controlador para o widget.
          controller: adminMessage,
          // Define o tipo de teclado como texto.
          keyBoardType: TextInputType.text,
          // Placeholder para o campo de entrada.
          hintText: 'Defina uma mensagem relevante ao chamado',
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
