import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:get/get.dart';

import '../../../Constants/text_strings.dart';
import '../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../../../Utils/Helper/helper_controller.dart';

class MailVerificationController extends GetxController {
  late Timer timer;
  // Variável para contar as tentativas
  int _attempts = 0;

  // Chamado quando o controlador é inicializado. Configura as operações iniciais.
  @override
  void onInit() {
    super.onInit();
    // Inicialmente, envia o e-mail de verificação
    sendVerificationEmail();
    // Define o timer para verificar automaticamente a verificação
    setTimerForAutoRedirect();
  }

  /// Método para enviar ou reenviar um e-mail de verificação ao usuário
  void sendVerificationEmail() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      Helper.successSnackBar(
          title: "Sucesso", message: "E-mail enviado com sucesso!");
    } catch (e) {
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }

  /// Configura um timer para verificar periodicamente se o usuário verificou o e-mail e,
  /// em caso afirmativo, redireciona para a tela inicial
  void setTimerForAutoRedirect() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        await Future.delayed(const Duration(seconds: 1));
        // Recarrega as informações do usuário
        await FirebaseAuth.instance.currentUser?.reload();
      } catch (e) {
        throw ("Erro ao recarregar o usuário: $e");
      }

      final user = FirebaseAuth.instance.currentUser;

      // Se o e-mail do usuário foi verificado, cancela o timer e redireciona para a tela inicial
      if (user!.emailVerified) {
        timer.cancel();
        AuthenticationRepository.instance.setInitialScreen(user);
      } else if (_attempts > 20) {
        // Após 20 tentativas, o timer é cancelado e uma mensagem é exibida ao usuário
        timer.cancel();
        Helper.errorSnackBar(
            title: "Erro", message: "Verifique manualmente seu e-mail");
      }

      // Incrementa a contagem de tentativas
      _attempts++;
    });
  }

  /// Método para verificar manualmente se o e-mail do usuário foi verificado
  /// e, em caso afirmativo, redireciona para a tela inicial
  void manuallyCheckEmailVerifcationStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // Recarrega as informações do usuário
      await FirebaseAuth.instance.currentUser?.reload();
    } catch (e) {
      throw ("Erro ao recarregar o usuário: $e");
    }

    final user = FirebaseAuth.instance.currentUser;

    // Se o e-mail do usuário foi verificado, redireciona para a tela inicial
    if (user!.emailVerified) {
      AuthenticationRepository.instance.setInitialScreen(user);
    } else {
      // Se não, exibe uma mensagem de erro
      Helper.errorSnackBar(
        title: "Erro",
        message: "E-mail ainda não verificado",
      );
    }
  }
}
