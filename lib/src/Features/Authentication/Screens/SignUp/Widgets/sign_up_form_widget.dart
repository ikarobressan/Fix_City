import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../CommomWidgets/Buttons/primary_button.dart';
import '../../../../../Constants/sizes.dart';
import '../../../../../Constants/text_strings.dart';
import '../../../../../Utils/Helper/helper_controller.dart';
import '../../../Controllers/signup_controller.dart';

class SignUpFormWidget extends StatelessWidget {
  SignUpFormWidget({Key? key}) : super(key: key);

  // Formatters para os campos de telefone e CPF
  final MaskTextInputFormatter phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 30),
        child: Form(
          key: controller.signupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para o nome completo do usuário
              TextFormField(
                controller: controller.fullName,
                validator: (value) =>
                    value!.isEmpty ? 'O campo Nome não pode ficar vazio' : null,
                decoration: const InputDecoration(
                  label: Text(tFullName),
                  prefixIcon: Icon(LineAwesomeIcons.user),
                ),
              ),
              const Gap(10),
              // Campo para o email do usuário
              TextFormField(
                controller: controller.emailController,
                validator: Helper.validateEmail,
                decoration: const InputDecoration(
                  label: Text(tEmail),
                  prefixIcon: Icon(LineAwesomeIcons.envelope),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(10),
              // Campo para o número de telefone do usuário
              TextFormField(
                controller: controller.phoneNo,
                validator: (value) => value!.isEmpty
                    ? 'O campo Numero de Telefone não pode ficar vazio'
                    : null,
                inputFormatters: [phoneFormatter],
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  label: Text(tPhoneNo),
                  prefixIcon: Icon(LineAwesomeIcons.phone),
                ),
              ),
              const Gap(10),
              // Campo para o CPF do usuário
              TextFormField(
                controller: controller.cpf,
                validator: (value) => value!.isEmpty
                    ? 'O campo CPF não pode ficar vazio'
                    : GetUtils.isCpf(controller.cpf.text.trim())
                        ? null
                        : 'O CPF informado é invalido',
                inputFormatters: [cpfFormatter],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text(tCpf),
                  prefixIcon: Icon(CupertinoIcons.number),
                ),
              ),
              const Gap(10),
              // Campo para a senha do usuário
              Obx(
                // Obx é um widget reativo do GetX. Ele escuta mudanças nas variáveis observáveis (Rx)
                // dentro de seu escopo e reconstrói o widget automaticamente quando essas variáveis mudam.
                () => TextFormField(
                  controller: controller.password,
                  validator: Helper.validatePassword,
                  // Aqui, estamos usando a variável observável 'showPassword' para determinar se o texto
                  // do campo deve ser obscurecido ou não. Quando 'showPassword' muda, este TextFormField será
                  // reconstruído automaticamente.
                  obscureText: controller.showPassword.value ? false : true,
                  decoration: InputDecoration(
                    label: const Text(tPassword),
                    prefixIcon: const Icon(Icons.fingerprint),
                    // Este botão muda o valor de 'showPassword' quando pressionado, fazendo com que o texto
                    // do campo seja alternado entre visível e obscurecido.
                    suffixIcon: IconButton(
                      icon: controller.showPassword.value
                          ? const Icon(LineAwesomeIcons.eye)
                          : const Icon(LineAwesomeIcons.eye_slash),
                      onPressed: () => controller.showPassword.value =
                          !controller.showPassword.value,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: tFormHeight - 10),

// Botão para submeter o formulário
              Obx(
                // Novamente, Obx escuta mudanças na variável observável 'isLoading'.
                // Quando 'isLoading' muda, este botão será reconstruído automaticamente.
                () => MyPrimaryButton(
                  // Indica se o botão deve mostrar um indicador de carregamento.
                  isLoading: controller.isLoading.value,
                  text: "Cadastrar",
                  onPressed: controller.isFacebookLoading.value ||
                          controller.isGoogleLoading.value
                      ? () {}
                      : controller.isLoading.value
                          ? () {}
                          : () => controller
                              .createUser(controller.emailController.text),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
