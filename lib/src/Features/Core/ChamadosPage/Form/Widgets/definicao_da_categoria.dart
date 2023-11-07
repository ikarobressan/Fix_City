import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../Utils/Widgets/input_text_field.dart';

// Definição da classe para um widget que permite ao usuário definir uma categoria.
class DefinicaoCategoria extends StatelessWidget {
  
  // Construtor da classe que requer um `TextEditingController`.
  const DefinicaoCategoria({super.key, required this.categoryController});

  // Controlador para o campo de texto onde o usuário definirá a categoria.
  final TextEditingController categoryController;

  @override
  Widget build(BuildContext context) {
    // Construindo o widget.
    return Column(
      children: [
        // Widget para mostrar a etiqueta "Defina a categoria".
        Row(
          children: [
            Text(
              'Defina a categoria',
              // Define o estilo do texto.
              style: Theme.of(context).textTheme.headlineMedium, 
            ),
          ],
        ),
        
        // Um espaçamento vertical para dar separação entre a etiqueta e o campo de entrada.
        const Gap(6),
        
        // Widget personalizado `InputTextField` que é um campo de entrada estilizado.
        InputTextField(
          // Passando o controlador para o widget.
          controller: categoryController,
          // Define o tipo de teclado como texto.    
          keyBoardType: TextInputType.text,
          // Placeholder para o campo de entrada. 
          hintText: 'Defina a Categoria', 
          // Limita a entrada a uma única linha.    
          maxLines: 1,
          // Não oculta o texto (como faria para uma senha).                
          obscureText: false,                 
          
          // Função para validar a entrada. Retorna uma mensagem de erro se o valor for em branco.
          onValidator: (value) {
            return value.isBlank ? 'Insira uma categoria' : null;
          },
        ),
      ],
    );
  }
}
