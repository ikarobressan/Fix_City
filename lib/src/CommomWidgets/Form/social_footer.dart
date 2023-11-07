import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../Constants/colors.dart';
import '../../Constants/image_strings.dart';
import '../../Constants/text_strings.dart';
import '../../Features/Authentication/Controllers/login_controller.dart';
import '../Buttons/clickable_richtext_widget.dart';
import '../Buttons/social_button.dart';

// Widget que representa o rodapé contendo os botões de login social e um texto clicável.
class SocialFooter extends StatelessWidget {
  // Texto padrão à esquerda do texto clicável.
  final String text1;

  // Texto clicável.
  final String text2;

  // Função a ser executada ao clicar no texto clicável.
  final VoidCallback onPressed;

  const SocialFooter({
    Key? key,
    this.text1 = tDontHaveAnAccount,
    this.text2 = tSignup,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicialização do controller.
    final controller = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          // Botão de login com Google.
          Obx(
            () => SocialButton(
              // Logo do Google.
              image: googleLogo,
              // Cor de fundo do botão do Google.
              background: tGoogleBgColor,
              // Cor do texto do botão do Google.
              foreground: tGoogleForegroundColor,
              // Texto do botão do Google.
              text: '${tConnectWith.tr} ${tGoogle.tr}',
              // Se verdadeiro, mostra um indicador de carregamento.
              isLoading: controller.isGoogleLoading.value,
              // Define a ação do botão quando pressionado.
              onPressed:
                  // Verifica se o login do Facebook ou qualquer outra operação de carregamento está em andamento.
                  controller.isFacebookLoading.value || controller.isLoading.value ?
                      // Se o login do Facebook ou outra operação estiver carregando, desativa a ação do botão.
                      () {} :
                      // Caso contrário, verifica se o login do Google está em andamento.
                      controller.isGoogleLoading.value ?
                          // Se o login do Google estiver carregando, desativa a ação do botão.
                          () {} :
                          // Se nenhum carregamento estiver em andamento, inicia o processo de login do Google.
                          () => controller.googleSignIn(),
            ),
          ),

          const Gap(10),
          // Botão de login com Facebook.
          Obx(
            () => SocialButton(
              // Logo do Facebook.
              image: facebookLogo,
              // Cor do texto do botão do Facebook.
              foreground: tWhiteColor,
              // Cor de fundo do botão do Facebook.
              background: tFacebookBgColor,
              // Texto do botão do Facebook.
              text: '${tConnectWith.tr} ${tFacebook.tr}',
              // Se verdadeiro, mostra um indicador de carregamento.
              isLoading: controller.isFacebookLoading.value,
              // Verifica se o login do Google ou qualquer outra operação de carregamento está em andamento.
              onPressed: controller.isGoogleLoading.value ||
                      controller.isLoading.value
                  ?
                  // Se o login do Google ou outra operação estiver carregando, desativa a ação do botão.
                  () {}
                  :
                  // Caso contrário, verifica se o login do Facebook está em andamento.
                  controller.isFacebookLoading.value
                      ?
                      // Se o login do Facebook estiver carregando, desativa a ação do botão.
                      () {}
                      :
                      // Se nenhum carregamento estiver em andamento, inicia o processo de login do Facebook.
                      () => controller.facebookSignIn(),
            ),
          ),
          const Gap(20),
          // Texto clicável para direcionar o usuário a outra página (como cadastro).
          ClickableRichTextWidget(
            text1: text1.tr,
            text2: text2.tr,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
