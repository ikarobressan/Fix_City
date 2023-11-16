import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../Authentication/Models/user_model.dart';
import '../Controller/user_controller.dart';
import '../Form/Screens/add_new_report.dart';

class ChamadosPageBodyHeader extends StatelessWidget {
  const ChamadosPageBodyHeader({super.key, required this.formattedDate});

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();

    return StreamBuilder<UserModel?>(
      stream: userController.userStream,
      builder: (context, snapshot) {
        final user = snapshot.data;
        bool isAdmin = user?.isAdmin ?? false;

        // Construir a linha do cabeçalho com base no status de admin do usuário
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Chamados',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            !(isAdmin)
                ? Column(
                    children: [
                      const Gap(10),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => const ReportFormScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '+ Criar Chamado',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Row(),
          ],
        );
      },
    );
  }
}
