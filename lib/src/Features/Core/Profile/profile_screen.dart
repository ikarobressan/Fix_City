import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../CommomWidgets/Buttons/primary_button.dart';
import '../../../Constants/text_strings.dart';
import '../../../Controller/theme_controller.dart';
import '../../../Repository/AuthenticationRepository/authentication_repository.dart';
import '../../Authentication/Models/user_model.dart';
import '../../Authentication/Screens/Welcome/home_page.dart';
import '../ChamadosPage/Controller/user_controller.dart';
import 'Widgets/image_with_icon.dart';
import 'Widgets/profile_menu.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final ThemeController themeController = Get.find();

    /// Método para exibir um diálogo perguntando ao usuário se ele deseja sair do aplicativo.
    Future<bool> showExitDialog(BuildContext context) async {
      // Usando Completer para obter o resultado final
      final completer = Completer<bool>();

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Você deseja sair?'),
          content: const Text('Você realmente deseja sair do aplicativo?'),
          actions: [
            SizedBox(
              width: 100,
              child: OutlinedButton(
                onPressed: () {
                  // Indica que o usuário não quer sair
                  Navigator.of(ctx).pop();
                  completer.complete(false);
                },
                child: const Text("Não"),
              ),
            ),
            MyPrimaryButton(
              isFullWidth: false,
              onPressed: () {
                // Indica que o usuário quer sair
                Navigator.of(ctx).pop();
                completer.complete(true);
              },
              text: "Sim",
            ),
          ],
        ),
      );

      return completer.future;
    }

    return Obx(
      () {
        final isDark = themeController.isDarkMode.value;

        return WillPopScope(
          onWillPop: () async {
            bool shouldExit = await showExitDialog(context);
            shouldExit ? SystemNavigator.pop() : null;
            // Previne a ação padrão do botão de voltar
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              // leading: IconButton(
              //   onPressed: () => Get.back(),
              //   icon: const Icon(LineAwesomeIcons.angle_left),
              // ),
              automaticallyImplyLeading: false,
              title: Text(
                profile,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              actions: [
                IconButton(
                  onPressed: themeController.toggleTheme,
                  icon: Icon(
                    isDark ? LineAwesomeIcons.moon : LineAwesomeIcons.sun,
                  ),
                  iconSize: 26,
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    /// -- IMAGE with ICON
                    const ImageWithIcon(),
                    const Gap(10),
                    StreamBuilder<UserModel?>(
                      stream: userController.userStream,
                      builder: (context, snapshot) {
                        UserModel? user = snapshot.data;
                        return Column(
                          children: [
                            Text(
                              user?.fullName ?? 'Fulano de Tal',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              user?.email ?? 'email@email.com',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        );
                      },
                    ),
                    const Gap(20),

                    /// -- BUTTON
                    MyPrimaryButton(
                      isFullWidth: false,
                      width: 200,
                      text: editProfile,
                      onPressed: () {
                        //* Proxima Feature
                        Get.to(() => UpdateProfileScreen());
                      },
                    ),
                    const Gap(30),
                    const Divider(),
                    const Gap(10),

                    /// -- MENU
                    // ProfileMenuWidget(
                    //   title: "Configurações",
                    //   icon: LineAwesomeIcons.cog,
                    //   onPress: () {},
                    // ),
                    // ProfileMenuWidget(
                    //   title: "Informações",
                    //   icon: LineAwesomeIcons.info,
                    //   onPress: () {},
                    // ),
                    ProfileMenuWidget(
                      title: "Sair",
                      icon: LineAwesomeIcons.alternate_sign_out,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: () => _showLogoutModal(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _showLogoutModal() {
    Get.defaultDialog(
      title: "SAIR",
      titleStyle: const TextStyle(fontSize: 20),
      content: const Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text("Tem certeza que gostaria\n de sair do aplicativo?"),
      ),
      confirm: MyPrimaryButton(
        isFullWidth: false,
        onPressed: () {
          Get.offAll(() => const WelcomeScreen());
          AuthenticationRepository.instance.logout();
        },
        text: "Sim",
      ),
      cancel: SizedBox(
        width: 100,
        child: OutlinedButton(
          onPressed: () => Get.back(),
          child: const Text("Não"),
        ),
      ),
    );
  }
}
