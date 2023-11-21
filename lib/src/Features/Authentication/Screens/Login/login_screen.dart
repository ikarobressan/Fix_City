import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../CommomWidgets/Form/form_divider_widget.dart';
import '../../../../CommomWidgets/Form/form_header_widget.dart';
import '../../../../CommomWidgets/Form/social_footer.dart';
import '../../../../Constants/image_strings.dart';
import '../../../../Constants/text_strings.dart';
import '../SignUp/signup_screen.dart';
import '../Welcome/home_page.dart';
import 'Widgets/login_form_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // AppBar com botão de retorno para a tela de boas-vindas
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30.0),
            onPressed: () {
              Get.offAll(() => const WelcomeScreen());
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho do formulário de login
                const FormHeaderWidget(
                  image: homeImage,
                  title: tLoginTitle,
                  subTitle: tLoginSubTitle,
                ),
                // Widget do formulário de login
                const LoginFormWidget(),
                // Divisor gráfico entre formulário de login e rodapé
                const MyFormDividerWidget(),
                // Rodapé com opção de registro
                SocialFooter(
                  text1: tDontHaveAnAccount,
                  text2: tSignup,
                  onPressed: () => Get.off(() => const SignupScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
