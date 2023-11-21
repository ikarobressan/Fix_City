// Importações necessárias para o funcionamento da tela.
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/image_strings.dart';
import '../../../../Constants/text_strings.dart';
import '../../../../Controller/theme_controller.dart';
import '../Login/login_screen.dart';
import '../SignUp/signup_screen.dart';

// Definição da tela de boas-vindas.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Obtém as "medidas" da tela.
    var mediaQuery = MediaQuery.of(context);
    var width = mediaQuery.size.width;
    var height = mediaQuery.size.height;

    // Obtém o controle do tema para verificar se está no modo escuro.
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;

    // Construção da tela.
    return SafeArea(
      child: Scaffold(
        // Define a cor de fundo com base no modo escuro ou claro.
        backgroundColor: isDark ? tDarkColor : tWhiteColor,
        body: Column(
          children: [
            // Imagem de boas-vindas.
            SizedBox(
              height: 300,
              child: Image(
                image: const AssetImage(homeImage),
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  // Centraliza os elementos na tela.
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        // Texto de boas-vindas.
                        Text(
                          tWelcomeTitle,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
                    const Gap(50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botão de login.
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                Get.to(() => const LoginScreen()),
                            child: Text(
                              tLogin.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    color:
                                        isDark ? blackColor : tPrimaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ),
                        ),
                        const Gap(20),
                        // Botão de inscrição.
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                Get.to(() => const SignupScreen()),
                            child: Text(
                              tSignup.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    color: isDark ? blackColor : whiteColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
