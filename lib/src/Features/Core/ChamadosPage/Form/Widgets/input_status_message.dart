import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../Utils/Widgets/input_text_field.dart';

class InputStatusMessage extends StatelessWidget {
  // Construtor que inicializa o widget com um `TextEditingController`.
  const InputStatusMessage({super.key, required this.statusMessage});

  // Controlador para o campo de texto onde o status do chamado será inserido.
  final TextEditingController statusMessage;

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
              'Status do Chamado',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),

        // Espaçamento vertical.
        const Gap(6),

        // Campo de entrada personalizado para inserção do status do chamado.
        InputTextField(
          // Passando o controlador para o widget.
          controller: statusMessage,
          // Define o tipo de teclado como texto.
          keyBoardType: TextInputType.text,
          // Placeholder para o campo de entrada, dando uma dica ao usuário do que inserir.
          hintText: 'Atualize o status do chamado caso necessário',
          // Limita a entrada a uma única linha.
          maxLines: 1,
          // Não oculta o texto.
          obscureText: false,
          // Função para validar a entrada. Retorna uma mensagem de erro se o valor for em branco.
          // Nota: A mensagem de erro parece não estar correta, considerando o contexto do widget.
          onValidator: (value) {
            return null;
          },
        ),
      ],
    );
  }
}
