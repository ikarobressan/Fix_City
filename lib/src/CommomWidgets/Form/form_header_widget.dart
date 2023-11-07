import 'package:flutter/material.dart';

// Widget personalizado para exibir um cabeçalho com imagem, título e subtítulo.
class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    Key? key,
    this.imageColor,
    this.heightBetween,
    required this.title,
    required this.subTitle,
    this.imageHeight = 0.15,
    required this.image,
    this.textAlign,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  // Cor para ser aplicada à imagem.
  final Color? imageColor;

  // Altura da imagem como uma fração da altura total da tela.
  final double imageHeight;

  // Espaço entre a imagem e o título.
  final double? heightBetween;

  // Título para ser exibido abaixo da imagem.
  final String title;

  // Subtítulo para ser exibido abaixo do título.
  final String subTitle;

  // Caminho da imagem a ser exibida.
  final String image;

  // Alinhamento do subtítulo.
  final TextAlign? textAlign;

  // Alinhamento da coluna.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    // Obtem as dimensões da tela.
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        // Exibe a imagem no cabeçalho.
        Image(
          image: AssetImage(image),
          color: imageColor,
          height: size.height * imageHeight,
        ),
        // Adiciona um espaço vertical entre a imagem e o título.
        SizedBox(height: heightBetween),
        // Exibe o título.
        Text(
          title,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        // Exibe o subtítulo.
        Text(
          subTitle,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
