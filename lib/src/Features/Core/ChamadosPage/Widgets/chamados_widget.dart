import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Constants/colors.dart';
import '../../../../Controller/theme_controller.dart';
import '../../../Authentication/Models/user_model.dart';
import '../Controller/user_controller.dart';
import '../Form/Screens/edit_report.dart';
import '../model/chamados_model.dart';

class ChamadosWidget extends StatefulWidget {
  // Construtor recebe um objeto ReportingModel e opcionalmente um UserModel
  const ChamadosWidget(this._reportingModel, {this.userModel, super.key});
  final ReportingModel _reportingModel;
  final UserModel? userModel;

  @override
  State<ChamadosWidget> createState() => _ChamadosWidgetState();
}

class _ChamadosWidgetState extends State<ChamadosWidget> {
  // Variável para controlar o estado do checkbox
  bool isDone = true;

  @override
  Widget build(BuildContext context) {
    // Obtém instância do controlador de tema usando Get.find()
    final ThemeController themeController = Get.find();

    // Obtém o estado atual do modo escuro/claro
    final isDark = themeController.isDarkMode.value;

    // Obtém instância do controlador de usuário usando Get.find()
    final UserController userController = Get.find();

    return StreamBuilder<UserModel?>(
      stream: userController.userStream,
      builder: (context, snapshot) {
        final user = snapshot.data;

        // Verifica se o usuário é um administrador
        bool isAdmin = user?.isAdmin ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: double.infinity,
            // Define a altura do contêiner com base em se há uma mensagem a ser exibida
            height: widget._reportingModel.showMessage ? 230 : 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // Define a cor de fundo com base no modo escuro/claro
              color: isDark ? tDarkCard : Colors.white70,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Adiciona um Gap (espaço) com base no estado do chamado
                        widget._reportingModel.isDone
                            ? const Gap(02)
                            : const Gap(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget._reportingModel.referPoint,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            widget._reportingModel.isDone
                                ? Checkbox(
                                    // Apenas para administradores
                                    value: isDone,
                                    activeColor: Colors.green,
                                    onChanged: ((value) {
                                      setState(() {
                                        isDone = isDone;
                                      });
                                    }),
                                  )
                                : const Gap(0),
                          ],
                        ),
                        const Gap(6),
                        Text(
                          widget._reportingModel.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                          // Evita que o texto transborde
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(6),
                        Text(
                          // Verifica se a categoria é "outro" e exibe a descrição personalizada
                          widget._reportingModel.category != Category.outro
                              ? widget
                                  ._reportingModel.category.categoryDescription
                              : widget._reportingModel.definicaoCategoria,
                          style: Theme.of(context).textTheme.bodyLarge,
                          // Evita que o texto transborde
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Container(
                              width: 120,
                              height: 28,
                              decoration: BoxDecoration(
                                color: tPrimaryColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 6,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget._reportingModel.formattedDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Gap(10),
                            if (isAdmin)
                              GestureDetector(
                                onTap: () {
                                  // Navega para a tela de edição de chamado
                                  Get.to(
                                    () => EditReportFormScreen(
                                      reportId:
                                          widget._reportingModel.chamadoId,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 90,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: tPrimaryColor,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Editar',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Gap(14),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Status do Chamado: ${widget._reportingModel.statusMessage}',
                                    // Evita que o texto transborde
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(10),
                            // Verifica se há uma mensagem do sistema para exibir
                            widget._reportingModel.showMessage
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Mensagem do Sistema: ${widget._reportingModel.messageString}',
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(),
                          ],
                        ),
                      ],
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
