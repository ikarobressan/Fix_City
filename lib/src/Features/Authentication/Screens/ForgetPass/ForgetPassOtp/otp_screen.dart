import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../Constants/colors.dart';
import '../../../../../Constants/text_strings.dart';
import '../../../../../Controller/theme_controller.dart';
import '../../../Controllers/otp_controller.dart';

/// [OTPScreen] é uma tela que permite ao usuário inserir
/// e verificar um OTP (One-Time Password) recebido.
class OTPScreen extends StatelessWidget {
  // Construtor do widget
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
    String otp = '';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30.0,
            color: isDark ? whiteColor : blackColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título da tela
              Text(
                tOtpTitle,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 80.0,
                ),
              ),
              // Subtítulo da tela
              Text(
                tOtpSubTitle.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Gap(40),
              // Mensagem informando o usuário sobre o OTP
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  tOtpMessage,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const Gap(20),
              // Campo para inserção do OTP
              OtpTextField(
                mainAxisAlignment: MainAxisAlignment.center,
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                onSubmit: (code) {
                  // Função chamada quando o usuário preenche todos os campos do OTP
                  otp = code;
                  OTPController.instance.verifyOTP(otp);
                },
              ),
              const Gap(20),
              // Botão para continuar após a inserção do OTP
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Função para verificar o OTP inserido pelo usuário
                    OTPController.instance.verifyOTP(otp);
                  },
                  child: const Text(tNext),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
