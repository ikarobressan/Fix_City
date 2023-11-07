import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../Screens/ChangePass/password_change_screen.dart';

class OTPController extends GetxController {
  // Cria uma instância única deste controlador.
  static OTPController get instance => Get.find();

  void verifyOTP(String otp) async {
    try {
      var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);

      // Se o OTP for verificado corretamente, redireciona o usuário para a tela de mudança de senha.
      if (isVerified) {
        Get.to(() => const PasswordChangeScreen());
      } else {
        // Se o OTP não for verificado corretamente, mostra uma snackbar vermelha informando o erro.
        _showErrorSnackbar(
          'Erro na Verificação',
          'OTP incorreto. Por favor, tente novamente.',
        );
      }
    } catch (e) {
      // Se ocorrer algum erro durante a verificação, mostra uma snackbar vermelha informando o erro.
      log('Erro de OTP: $e');
      _showErrorSnackbar('Erro', 'Ocorreu um erro ao verificar o OTP: $e');
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
