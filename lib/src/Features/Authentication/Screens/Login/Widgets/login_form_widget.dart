import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../CommomWidgets/Buttons/primary_button.dart';
import '../../../../../Constants/colors.dart';
import '../../../../../Constants/text_strings.dart';
import '../../../../../Utils/Helper/helper_controller.dart';
import '../../../Controllers/login_controller.dart';
import '../../ForgetPass/ForgetPassOptions/foregt_pass_modal_bottom_sheet.dart';

/// [LoginFormWidget] é um widget que contém os campos e botões
/// necessários para realizar o login do usuário.
class LoginFormWidget extends StatelessWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Controlador para as funções de login e estados associados.
    final controller = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Form(
        key: controller.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Campo E-mail
            TextFormField(
              validator: Helper.validateEmail,
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(LineAwesomeIcons.user),
                labelText: tEmail,
                hintText: tEmail,
              ),
            ),
            const Gap(10),

            //* Campo Senha com opção de mostrar/esconder a senha.

            // Obx é usado para observar as mudanças do estado e reconstruir o widget quando
            // o valor observado (showPassword) muda.
            Obx(
              () => TextFormField(
                controller: controller.passwordController,
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
            const Gap(10),

            // ...

            Align(
              alignment: Alignment.centerRight,
              // Botão que abre o modal de "esqueci minha senha".
              child: TextButton(
                onPressed: () =>
                    ForgetPasswordScreen.buildShowModalBottomSheet(context),
                child: Text(
                  tForgetPassword,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: tFacebookBgColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),

// ...

            /// Botão de login.

            // Obx é usado para observar a mudança de estado e reconstruir o widget quando
            // os valores observados (isLoading, isFacebookLoading, isGoogleLoading) mudam.
            Obx(
              () => MyPrimaryButton(
                isLoading: controller.isLoading.value ? true : false,
                text: tLogin,

                // O botão ficará desabilitado se qualquer um dos processos de carregamento estiver ativo.
                onPressed: controller.isFacebookLoading.value ||
                        controller.isGoogleLoading.value
                    ? () {}
                    : controller.isLoading.value
                        ? () {}
                        : () => controller.login(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
