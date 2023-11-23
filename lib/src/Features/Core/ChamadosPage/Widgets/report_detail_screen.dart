import 'dart:developer';

import 'package:easy_stepper/easy_stepper.dart';
import '../../Category/provider/firestore_provider.dart';
import 'observation_admin.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../Constants/colors.dart';
import '../../../../Controller/theme_controller.dart';
import '../Controller/chamados_controller.dart';
import '../model/chamados_model.dart';
import 'full_screen_image.dart';
import 'full_screen_video_player.dart';
import 'video_player.dart';

class ReportDetailScreen extends StatefulWidget {
  const ReportDetailScreen({super.key, required this.reportingModel});
  final ReportingModel reportingModel;

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  // Inicializar o controlador
  final ReportController reportController = Get.find();

  final String emptyVideo = 'vídeo não disponivel';

// Criar uma lista para armazenar as URLs das imagens
  String? imageUrls;
  String? videoUrls;

  @override
  void initState() {
    super.initState();

    // Chamar o método para obter as URLs das imagens quando a tela é inicializada
    _loadImages();

    // mudar o param "ready" para true em todos os comentarios do admin
    readyComments();
  }

  void _loadImages() async {
    imageUrls = await reportController.getChamadoImage(
      widget.reportingModel.chamadoId!,
      widget.reportingModel.userId!,
    );
    log('Imagens recuperadas: $imageUrls');
    videoUrls = await reportController.getChamadoVideo(
      widget.reportingModel.chamadoId!,
      widget.reportingModel.userId!,
    );
    log('Videos recuperados: $videoUrls');
    // Atualizar o estado para refletir as mudanças
    setState(() {});
  }

  void readyComments() {
    List<dynamic> listaAtualizada =
        widget.reportingModel.observationsAdmin.map((item) {
      // Modifique o campo 'name' em cada dicionário
      item['ready'] = true;
      return item;
    }).toList();

    FirestoreProvider.putDocument(
        "Chamados", {"observations_admin": listaAtualizada},
        documentId: widget.reportingModel.chamadoId);
  }

  Future<bool> safeBack() async {
    if (Get.currentRoute != '/') {
      // Verifica se a tela atual não é a tela inicial
      Get.back();
    }
    // Indica que o evento "voltar" foi tratado e evita que o aplicativo feche.
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> listObs = widget.reportingModel.observationsAdmin as List;

    final ThemeController themeController = Get.find();
    List<String> statusMessageList = [
      "Enviado",
      "Em andamento",
      "Encerrado",
      "Cancelado"
    ];
    dynamic activeStep = statusMessageList.indexOf(
      widget.reportingModel.statusMessage.toString(),
    );
    log('Imagens recuperadas: $imageUrls');
    final isDark = themeController.isDarkMode.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalhes do Chamado",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        backgroundColor: isDark ? tDarkColor : whiteColor,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data do Chamado
              Column(
                children: [
                  EasyStepper(
                    activeStep: activeStep,
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    internalPadding: 0,
                    activeStepTextColor: Colors.green,
                    activeStepBackgroundColor: Colors.green,
                    activeStepIconColor: Colors.green,
                    finishedStepTextColor: Colors.black,
                    finishedStepBackgroundColor: Colors.green,
                    disableScroll: true,
                    showLoadingAnimation: false,
                    stepRadius: 15,
                    lineStyle: const LineStyle(
                      lineLength: 70,
                      lineType: LineType.normal,
                      defaultLineColor: Colors.grey,
                      finishedLineColor: Colors.green,
                    ),
                    steps: List.generate(
                      statusMessageList.length,
                      (index) => EasyStep(
                        customStep: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.green,
                          child: CircleAvatar(
                            radius: 7,
                            backgroundColor: activeStep >= index
                                ? activeStep == statusMessageList.length
                                    ? Colors.red
                                    : Colors.green
                                : Colors.grey,
                          ),
                        ),
                        title: statusMessageList[index],
                      ),
                    ),
                  ),
                  const Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Data do Chamado:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.reportingModel.formattedDate,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Endereço
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Endereço:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.reportingModel.address!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Número do Endereço
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Número do Endereço:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.reportingModel.addressNumber!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // CEP
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "CEP:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.reportingModel.cep!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Ponto de Referência
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Ponto de Referência:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.reportingModel.referPoint!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Descrição
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Descrição:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.reportingModel.description!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Categoria
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Categoria:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    // color: isDark ? blackContainer : whiteContainer,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.reportingModel.category!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              if (widget.reportingModel.category == 'Outro') ...[
                const Gap(12),
                // Categoria Definida
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Descrição da Categoria:",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                    const Gap(6),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? blackContainer : whiteContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.reportingModel.definicaoCategoria!,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
              ],
              const Gap(12),
              // Status da Chamado
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Status do Chamado:",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    // color: isDark ? blackContainer : whiteContainer,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? blackContainer : whiteContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.reportingModel.statusMessage!,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Imagem/Vídeo do Chamado:',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                  const Gap(10),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: videoUrls != emptyVideo
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.center,
                        children: [
                          if (imageUrls != null && imageUrls!.isNotEmpty)
                            Expanded(
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => FullScreenImage(
                                        imageUrl: imageUrls!,
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    imageUrls!,
                                    fit: BoxFit.cover,
                                    // Altura da imagem
                                    height: 300,
                                    // Largura da imagem
                                    width: 150,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          'Erro ao carregar a imagem.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          if (videoUrls != emptyVideo)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => FullScreenVideoPlayer(
                                      videoUrl: videoUrls!,
                                    ),
                                  );
                                },
                                child: VideoPlayerWidget(
                                  videoUrl: videoUrls ?? '',
                                  height: 300,
                                  width: 150,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(20),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Observações do admin:',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ],
              ),
              listObs[0].length != 1
                  ? Column(
                      children: List.generate(
                        listObs.length,
                        (index) => StepWidget(
                            obs: listObs[index]["observation"],
                            data: listObs[index]["data"],
                            status: listObs[index]["status"]),
                      ),
                    )
                  : const Text("Sem observações")
            ],
          ),
        ),
      ),
    );
  }
}
