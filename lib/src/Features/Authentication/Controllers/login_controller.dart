import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Constants/text_strings.dart';
import '../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../../../Repository/UserRepository/user_repository.dart';
import '../../../Utils/Helper/helper_controller.dart';
import '../../Core/NavBar/navigation_bar.dart';
import '../Models/user_model.dart';
import '../Screens/ForgetPass/ForgetPassOtp/otp_screen.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Observáveis usados para controlar a visibilidade da senha e ações de carregamento
  final showPasswod = false.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  // Controladores de texto e chaves de formulário para interação com os campos de entrada e validação
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final resetPassEmailFormKey = GlobalKey<FormState>();
  final resetPasswordEmailFormKey = GlobalKey<FormState>();

  /// Realiza login usando email e senha
  Future<void> login() async {
    try {
      isLoading.value = true;

      // Verifica a validade do formulário
      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      final auth = AuthenticationRepository.instance;

      // Realiza login usando email e senha
      final loginResult = await auth.loginWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Se o login não for bem-sucedido, mostra uma snackbar de erro
      if (!loginResult.success) {
        Helper.errorSnackBar(
          title: tOps,
          message: loginResult.errorMessage!,
        );
        isLoading.value = false;
        return;
      }

      // Define a tela inicial após o login bem-sucedido
      auth.setInitialScreen(auth.firebaseUser);
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }

  /// Realiza login usando Google
  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;
      final auth = AuthenticationRepository.instance;

      // Realiza login usando o Google
      await auth.signInWithGoogle();
      isGoogleLoading.value = false;

      // Verifica se o usuário já existe no repositório, caso contrário, cria um novo usuário
      if (!await UserRepository.instance.recordExist(auth.getUserEmail)) {
        UserModel user = UserModel(
          id: auth.getUserID,
          email: auth.getUserEmail,
          password: '',
          fullName: auth.getDisplayName,
          phoneNo: auth.getPhoneNo,
        );
        await UserRepository.instance.createUserWithGoogle(user);
        Get.to(const MyNavigationBar());
      }
    } catch (e) {
      isGoogleLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }

  /// Realiza login usando Facebook
  Future<void> facebookSignIn() async {
    try {
      isFacebookLoading.value = true;
      final auth = AuthenticationRepository.instance;

      // Realiza login usando o Facebook
      await auth.signInWithFacebook();

      // Verifica se o usuário já existe no repositório, caso contrário, cria um novo usuário
      if (!await UserRepository.instance.recordExist(auth.getUserID)) {
        UserModel user = UserModel(
          id: auth.getUserID,
          email: auth.getUserEmail,
          password: '',
          fullName: auth.getDisplayName,
          phoneNo: auth.getPhoneNo,
        );
        await UserRepository.instance.createUser(user);
      }
      isFacebookLoading.value = false;
    } catch (e) {
      isFacebookLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }

  /// Envia um email de redefinição de senha
  Future<void> resetPasswordEmail() async {
    try {
      // Verifica a validade do formulário de redefinição de senha
      if (resetPassEmailFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }
      isLoading.value = true;

      // Solicita um email de redefinição de senha
      await AuthenticationRepository.instance.resetPasswordEmail(
        emailController.text.trim(),
      );
      Get.to(() => const OTPScreen());
    } catch (e) {
      isLoading.value = false;
      Helper.errorSnackBar(title: tOps, message: e.toString());
    }
  }
}
