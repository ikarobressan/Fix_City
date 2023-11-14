import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Importando CupertinoIcons
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../Constants/text_strings.dart';
import '../../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../Login/login_screen.dart';
import '../Welcome/home_page.dart';

class UpdateOrRegisterScreen extends StatelessWidget {
  const UpdateOrRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controlador associado para manipulação de eventos
    // final controller = Get.put(AuthenticationRepository());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícone de telefone
                const Icon(CupertinoIcons.phone, size: 120),
                const Gap(80),
                // Título da tela
                Text(
                  verifyCredentials,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Gap(30),
                // Subtítulo 1
                Text(
                  verfyPhoneSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Gap(30),
                // Subtítulo 2
                Text(
                  verifyPhoneSubtitle2,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Gap(120),
                // Botão "Voltar", qpara voltar para a tela de Login
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      Get.offAll(() => const LoginScreen());
                    },
                    child: Text(
                      "VOLTAR",
                      style: GoogleFonts.poppins(
                        letterSpacing: 1.0,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Gap(80),
                // Botão "Voltar para o login"
                TextButton(
                  onPressed: () {
                    Get.offAll(() => const WelcomeScreen());
                    AuthenticationRepository.instance.logout();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LineAwesomeIcons.alternate_long_arrow_left),
                      const Gap(5),
                      Text(
                        backToLogin,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
