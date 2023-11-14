import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_safe_city/src/Features/Core/Category/provider/firestore_provider.dart';

import '../../../../../Constants/colors.dart';
import '../../model/chamados_model.dart';
import '../../Widgets/chamados_widget.dart';
import '../../Widgets/report_detail_screen.dart';
import '../chamados_screen.dart';

class UserChamadosNew extends StatelessWidget {
  const UserChamadosNew({
    super.key,
    required this.widget,
    required this.usuarioLogado,
  });

  final ChamadosScreen widget;
  final User? usuarioLogado;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreProvider.getDocumentsBy(
          "Chamados", "Id do Usuario", usuarioLogado!.uid),
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        // Verificar se há erro no snapshot
        if (snapshot.hasError) {
          log('Erro: ${snapshot.error}');
        }

        // Verificar se o snapshot está carregando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Verificar se o snapshot tem dados e não é nulo
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text(
              'Nenhum dado disponível',
              style: TextStyle(color: whiteColor),
            ),
          );
        }

        // Se tudo estiver ok, construir a lista
        final reportList = snapshot.data!.map(
          (doc) {
            return ReportingModel.fromSnapshot(
              doc as QueryDocumentSnapshot<Map<String, dynamic>>,
            );
          },
        ).toList();

        // Construir a lista de relatórios
        return ListView.builder(
          itemBuilder: (context, index) {
            final report = reportList[index];

            // Adicionar um GestureDetector para lidar com o toque nos relatórios
            return GestureDetector(
              onTap: () {
                // Navegar para a tela de detalhes do relatório
                Get.to(() => ReportDetailScreen(reportingModel: report));
              },
              child: ChamadosWidget(report), // Exibir o widget do relatório
            );
          },
          itemCount: reportList.length, // Definir o número de itens na lista
        );
      },
    );
  }
}
