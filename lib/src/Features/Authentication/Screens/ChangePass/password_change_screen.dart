import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../Constants/colors.dart';
import '../../../../Constants/text_strings.dart';
import '../../../../Controller/theme_controller.dart';
import '../../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../../Controllers/login_controller.dart';
import '../Login/login_screen.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final controller = Get.put(LoginController());
  final _authRepo = Get.find<AuthenticationRepository>();

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Digite sua nova senha',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Gap(30),
            // Obx é usado para observar as mudanças do estado e reconstruir o widget quando
            // o valor observado (showPassword) muda.
            Obx(
              () => TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value!.isEmpty) return 'Insira sua senha.';
                  return null;
                },
                obscureText: controller.showPasswod.value ? false : true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.fingerprint_rounded),
                  labelText: tPassword,
                  hintText: tPassword,

                  // Botão para alternar a visibilidade da senha.
                  // A visibilidade da senha é controlada pelo valor de 'showPassword' no controlador.
                  suffixIcon: IconButton(
                    icon: controller.showPasswod.value
                        ? const Icon(LineAwesomeIcons.eye)
                        : const Icon(LineAwesomeIcons.eye_slash),
                    onPressed: () => controller.showPasswod.value =
                        !controller.showPasswod.value,
                  ),
                ),
              ),
            ),
            const Gap(20),
            Obx(
              () => TextFormField(
                controller: confirmPasswordController,
                validator: (value) =>
                    value!.isEmpty ? 'Insira sua senha.' : null,
                obscureText: controller.showPasswod.value ? false : true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.fingerprint_rounded),
                  labelText: 'Confrimar Senha',
                  hintText: 'Confirmar Senha',

                  // Botão para alternar a visibilidade da senha.
                  // A visibilidade da senha é controlada pelo valor de 'showPassword' no controlador.
                  suffixIcon: IconButton(
                    icon: controller.showPasswod.value
                        ? const Icon(LineAwesomeIcons.eye)
                        : const Icon(LineAwesomeIcons.eye_slash),
                    onPressed: () => controller.showPasswod.value =
                        !controller.showPasswod.value,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                handlePasswordChange;
                Get.offAll(() => const LoginScreen());
              },
              child: const Text('Alterar Senha'),
            ),
          ],
        ),
      ),
    );
  }

  void handlePasswordChange() async {
    if (passwordController.text == confirmPasswordController.text) {
      try {
        await _authRepo.resetPasswordWithOTP(
          passwordController.text,
          confirmPasswordController.text,
        );

        Get.snackbar(
          'Sucesso',
          'Senha alterada com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (error) {
        Get.snackbar(
          'Erro',
          'Ocorreu um erro ao alterar a senha.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Erro',
        'As senhas não coincidem.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
