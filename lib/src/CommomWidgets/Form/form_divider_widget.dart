import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/theme_controller.dart';
import '../../constants/colors.dart';
import '../../constants/text_strings.dart';

// Um widget personalizado que exibe um divisor horizontal com a palavra "OU" no centro.
class MyFormDividerWidget extends StatelessWidget {
  const MyFormDividerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtendo a instância do ThemeController para verificar se o tema escuro está ativo.
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    return Row(
      children: [
        // Primeira parte do divisor (à esquerda do texto "OU").
        Flexible(
          child: Divider(
            thickness: 1,
            indent: 30,
            color: Colors.grey.withOpacity(0.3),
            endIndent: 10,
          ),
        ),
        // Texto "OU" no centro.
        Text(
          tOR,
          style: Theme.of(context).textTheme.bodyLarge!.apply(
                // Se o modo escuro estiver ativo, a cor do texto será um branco semi-transparente.
                // Caso contrário, será um preto semi-transparente.
                color: isDark
                    ? tWhiteColor.withOpacity(0.5)
                    : tDarkColor.withOpacity(0.5),
              ),
        ),
        // Segunda parte do divisor (à direita do texto "OU").
        Flexible(
          child: Divider(
            thickness: 1,
            indent: 10,
            color: Colors.grey.withOpacity(0.3),
            endIndent: 30,
          ),
        ),
      ],
    );
  }
}
