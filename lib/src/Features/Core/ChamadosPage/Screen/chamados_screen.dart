import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../CommomWidgets/Buttons/primary_button.dart';
import '../../../../Constants/colors.dart';
import '../../../../Controller/theme_controller.dart';
import '../../Category/provider/fireauth_provider.dart';
import '../model/chamados_model.dart';
import '../../../Authentication/Models/user_model.dart';
import '../Controller/user_controller.dart';
import '../Widgets/chamados_page_body_header.dart';
import 'list_chamados_screen.dart';

class ChamadosScreen extends StatefulWidget {
  const ChamadosScreen({this.userModel, this.reportingModel, super.key});
  final ReportingModel? reportingModel;
  final UserModel? userModel;

  @override
  State<ChamadosScreen> createState() => _ChamadosScreenState();
}

class _ChamadosScreenState extends State<ChamadosScreen> {
  /// Exibe um diálogo perguntando se o usuário deseja sair do aplicativo.
  /// Retorna `true` se o usuário confirmar a saída, e `false` caso contrário.
  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Você deseja sair?'),
            content: const Text(
              'Você realmente deseja sair do aplicativo?',
            ),
            actions: [
              SizedBox(
                width: 100,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Não"),
                ),
              ),
              MyPrimaryButton(
                isFullWidth: false,
                onPressed: () => Navigator.of(context).pop(true),
                text: "Sim",
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    /// Obtém instâncias dos controladores de usuário e tema usando `Get.find()`.
    final UserController userController = Get.find();
    final ThemeController themeController = Get.find();

    /// Define a data atual e a formata no formato "dd/mm/yyyy".
    DateTime currentDate = DateTime.now();
    final day = currentDate.day.toString().padLeft(2, '0');
    final month = currentDate.month;
    final year = currentDate.year;
    String formattedDate = "$day/$month/$year";
    User? usuarioLogado = FireauthProvider.getCurrentUser();

    if (usuarioLogado != null) {
      // Faça algo com o usuário logado
      log('Usuário logado: ${usuarioLogado.email}');
    } else {
      // Não há usuário logado
      log('Nenhum usuário logado.');
    }

    // Widget observável que reage às mudanças de estado (mudanças no modo escuro/claro)
    return Obx(
      () {
        // Define se o modo escuro está ativado ou não
        final isDark = themeController.isDarkMode.value;

        // Estrutura principal da página de chamados
        return SafeArea(
          child: Scaffold(
            // Chave baseada no modo escuro ou claro
            key: ValueKey(Get.isDarkMode),
        
            // Cor de fundo baseada no modo escuro ou claro
            backgroundColor: isDark ? tDarkColor : Colors.grey.shade200,
        
            // Barra de aplicativo
            appBar: AppBar(
              // Configurações de cores e aparência baseadas no modo escuro ou claro
              backgroundColor: isDark ? tDarkColor : whiteColor,
              foregroundColor: isDark ? Colors.black : whiteColor,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
        
              // Título exibindo informações do usuário
              title: StreamBuilder<UserModel?>(
                stream: userController.userStream,
                builder: (context, snapshot) {
                  final user = snapshot.data;
                  // bool isAdmin = user?.isAdmin ?? false;
                  if (user == null) {
                    return const Text('Nome de usuário não disponivel');
                  } else {
                    // Mostra a imagem e o nome do usuário
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber.shade400,
                        radius: 25,
                        child: Image.asset('assets/images/avatar.png'),
                      ),
                      title: Text(
                        'Olá, Bem-Vindo!',
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        user.fullName, //# Nome do usuário logado
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    );
                  }
                },
              ),
        
              // Ações na barra de aplicativos (calendário e notificações)
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.calendar,
                          color: isDark ? tWhiteColor : tDarkColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.bell,
                          color: isDark ? tWhiteColor : tDarkColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        
            // Corpo principal da página
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Gap(20),
                  ChamadosPageBodyHeader(formattedDate: formattedDate),
                  const Gap(20),
                  Expanded(
                    child: StreamBuilder<UserModel?>(
                      stream: userController.userStream,
                      builder: (context, snapshot) {
                        final user = snapshot.data;
                        bool isAdmin = user?.isAdmin ?? false;
        
                        // Mostra chamados para admin ou usuário comum
                        return isAdmin
                            ? AdminChamadosNew(
                                widget: widget,
                              )
                            : AdminChamadosNew(
                                widget: widget,
                                usuarioLogado: user?.id,
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
