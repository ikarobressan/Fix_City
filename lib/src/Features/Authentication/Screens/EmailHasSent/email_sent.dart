import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../Constants/text_strings.dart';
import '../../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../Welcome/home_page.dart';

class MailSend extends StatelessWidget {
  const MailSend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícone do envelope
                const Icon(LineAwesomeIcons.envelope_open, size: 100),
                const Gap(60),
                // Título da tela
                Text(
                  verifyEmailTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Gap(30),
                // Subtítulo 1
                Text(
                  passwordResetEmailSubTitle1,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const Gap(30),
                // Subtítulo 2
                Text(
                  passwordResetEmailSubTitle2,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const Gap(20),
                // Botão "Continuar"
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
                      Get.offAll(() => const WelcomeScreen());
                    },
                    child: Text(
                      continueButton.toUpperCase(),
                      style: GoogleFonts.poppins(
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Gap(60),
                // Botão "Reenviar e-mail"
                TextButton(
                  child: Text(
                    resendEmail,
                    style: GoogleFonts.poppins(),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
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
                        style: GoogleFonts.poppins(),
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
