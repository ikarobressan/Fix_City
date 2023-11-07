import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Constants/colors.dart';
import '../../Constants/text_strings.dart';

class Helper extends GetxController {
  //* ========= VALIDAÇÕES ========= *//

  /// Valida o formato do e-mail.
  static String? validateEmail(value) {
    // Verifica se o e-mail é vazio.
    if (value == null || value.isEmpty) return tEmailCannotEmpty;
    // Verifica se é um e-mail válido.
    if (!GetUtils.isEmail(value)) return tInvalidEmailFormat;
    return null;
  }

  /// Valida a força da senha.
  static String? validatePassword(value) {
    // Verifica se a senha é vazia.
    if (value == null || value.isEmpty) return 'Campo Senha não pode ser vazio';

    // Define o padrão para a senha.
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);

    // Verifica se a senha atende ao padrão.
    if (!regex.hasMatch(value)) {
      return 'A senha deve ter 8 caracteres, com uma letra maiúscula,\num número e um símbolo.';
    }
    return null;
  }

  //* =========== SNACK-BARS =========== *//

  /// Exibe uma snack-bar de sucesso.
  static successSnackBar({required title, message}) {
    // Configuração da snack-bar.
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tWhiteColor,
      backgroundColor: tSuccessSnackbar,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(12),
      icon: const Icon(
        LineAwesomeIcons.check_circle,
        color: tWhiteColor,
      ),
    );
  }

  /// Exibe uma snack-bar de aviso.
  static warningSnackBar({required title, message}) {
    // Configuração da snack-bar.
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tWhiteColor,
      backgroundColor: tWarningSnackbar,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(12),
      icon: const Icon(
        LineAwesomeIcons.exclamation_circle,
        color: tWhiteColor,
      ),
    );
  }

  /// Exibe uma snack-bar de erro.
  static errorSnackBar({required title, message}) {
    // Configuração da snack-bar.
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: tWhiteColor,
      backgroundColor: tErrorSnackbar,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(12),
      icon: const Icon(
        LineAwesomeIcons.times_circle,
        color: tWhiteColor,
      ),
    );
  }

  /// Exibe uma snack-bar moderna.
  static modernSnackBar({required title, message}) {
    // Configuração da snack-bar.
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      colorText: tWhiteColor,
      backgroundColor: Colors.blueGrey,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(12),
    );
  }
}
