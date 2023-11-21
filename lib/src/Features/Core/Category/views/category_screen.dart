import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Constants/colors.dart';
import '../../../../Controller/theme_controller.dart';
import '../../../Authentication/Models/user_model.dart';
import '../components/category_header.dart';
import '../components/category_title.dart';
import '../models/category.dart';
import '../provider/firestore_provider.dart';
import '../../ChamadosPage/Controller/user_controller.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

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
              foregroundColor: isDark ? blackColor : whiteColor,
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
              // actions: [
              //   IconButton(
              //     onPressed: themeController.toggleTheme,
              //     icon: Icon(
              //       isDark ? LineAwesomeIcons.moon : LineAwesomeIcons.sun,
              //     ),
              //     iconSize: 26,
              //   )
              // ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Gap(20),
                  CategoryHeader(formattedDate: formattedDate),
                  const Gap(20),
                  Expanded(
                    child: Scaffold(
                      body: StreamBuilder(
                        stream:
                            FirestoreProvider.getdocumentsStream('categories'),
                        builder:
                            (context, AsyncSnapshot<List<Category>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Erro ao carregar dados: ${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('Nenhuma categoria encontrada.'),
                            );
                          }

                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (ctx, i) =>
                                CategoryTile(snapshot.data?[i] as Category),
                          );
                        },
                      ),
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
