import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../Constants/colors.dart';
import '../../model/chamados_model.dart';
import '../../Controller/chamados_controller.dart';
import '../../Widgets/chamados_widget.dart';
import '../../Widgets/report_detail_screen.dart';
import '../chamados_screen.dart';

class UserChamados extends StatelessWidget {
  const UserChamados({
    super.key,
    required this.widget,
  });

  final ChamadosScreen widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ReportController().stream(),
      builder: (context, snapshot) {
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
        final reportList = snapshot.data!.docs.map(
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
