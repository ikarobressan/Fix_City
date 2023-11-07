// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../Constants/colors.dart';
import '../../../../../Controller/theme_controller.dart';
import '../../../../../Services/storage_service.dart';
import '../../model/chamados_model.dart';
import '../../Controller/chamados_controller.dart';
import '../Widgets/definicao_da_categoria.dart';
import '../Widgets/input_address.dart';
import '../Widgets/input_description.dart';
import '../Widgets/input_address_number.dart';
import '../Widgets/input_refer_point.dart';
import '../Widgets/input_zip_code.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({Key? key}) : super(key: key);

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final address = TextEditingController();
  final cep = TextEditingController();
  final referPoint = TextEditingController();
  final addressNumber = TextEditingController();
  final description = TextEditingController();
  final definicaoCategoria = TextEditingController();
  final messageString = TextEditingController();

  Category _selectedCategory = Category.buracoRua;

  //* Armazana imagens e videos no Realtime Database
  StorageService service = StorageService();
  String? imageUrl;
  String? videoUrl;

  //! Variáveis para armazenar os arquivos selecionados
  PlatformFile? selectedImageFile;
  PlatformFile? selectedVideoFile;

  //@ // Função para validar os dados inseridos e retornar true se estiverem corretos ou false caso contrário
  bool submitData() {
    // Verifica se todos os campos de texto estão vazios e se nenhuma imagem foi selecionada
    if (address.text.trim().isEmpty &&
        cep.text.trim().isEmpty &&
        referPoint.text.trim().isEmpty &&
        addressNumber.text.trim().isEmpty &&
        description.text.trim().isEmpty &&
        selectedImageFile.isBlank!) {
      //! Exibe um diálogo de erro informando que os campos estão vazios
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Dados Inválidos'),
          content: const Text(
            'Por favor, verifique se os dados foram preenchidos corretamente.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return false;
    }
    // Verifica se nenhuma imagem foi selecionado
    if (selectedImageFile == null) {
      // Exibe um diálogo informando que pelo menos uma imagem ou vídeo é obrigatório
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Arquivo Obrigatório'),
          content: const Text(
            'Por favor, envie pelo menos uma imagem ou vídeo.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      // Retorna false indicando que os dados não são válidos
      return false;
    }
    // Retorna true indicando que os dados são válidos
    return true;
  }

  //@ Função assíncrona para capturar uma imagem usando a câmera do dispositivo
  Future<void> _getImageFromCamera() async {
    // Registra o início da execução da função
    log('Iniciando _getImageFromCamera...');

    // Cria uma instância do seletor de imagens
    final ImagePicker picker = ImagePicker();

    // Aciona a câmera para capturar uma imagem
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    // Se uma imagem foi capturada
    if (pickedFile != null) {
      // Converte o arquivo XFile para o tipo File
      File file = File(pickedFile.path);

      // Atualiza o estado do widget com a imagem capturada
      setState(() {
        selectedImageFile = PlatformFile(
          name: pickedFile.name,
          path: pickedFile.path,
          size: file.lengthSync(),
          bytes: file.readAsBytesSync(),
        );
      });
    } else {
      // Exibe uma notificação informando que nenhuma imagem foi capturada
      Get.snackbar(
        'Ação Cancelada',
        'Você não tirou nenhuma foto ou vídeo.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  //@ Função assíncrona para obter um vídeo gravado pela câmera do dispositivo
  Future<void> _getVideoFromCamera() async {
    // Registra o início da execução da função
    log('Iniciando _getVideoFromCamera...');

    // Cria uma instância do seletor de imagens
    final ImagePicker picker = ImagePicker();

    try {
      // Aciona a câmera para gravar um vídeo
      final XFile? pickedFile =
          await picker.pickVideo(source: ImageSource.camera);

      // Se um vídeo foi gravado
      if (pickedFile != null) {
        log('Vídeo selecionado: ${pickedFile.path}');

        // Converte o arquivo XFile para o tipo File
        File file = File(pickedFile.path);

        // Atualiza o estado do widget com o vídeo selecionado
        setState(() {
          selectedVideoFile = PlatformFile(
            name: pickedFile.name,
            path: pickedFile.path,
            size: file.lengthSync(),
            bytes: file.readAsBytesSync(),
          );
        });
      } else {
        // Registra que a ação foi cancelada e nenhum vídeo foi gravado
        log('Ação cancelada. Nenhum vídeo foi gravado.');

        // Exibe uma notificação informando que nenhum vídeo foi gravado
        Get.snackbar(
          'Ação Cancelada',
          'Você não gravou nenhum vídeo.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      }
      // Captura e trata possíveis erros ao tentar gravar um vídeo
    } catch (e) {
      log('Erro ao tentar gravar vídeo: $e');

      // Exibe uma notificação informando sobre o erro
      Get.snackbar(
        'Erro',
        'Falha ao tentar gravar vídeo: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  // Função assíncrona para obter uma imagem da galeria do dispositivo
  Future<void> _getImageFromGallery() async {
    // Registra o início da execução da função
    log('Iniciando _getImageFromGallery...');

    // Aciona o seletor de arquivos para escolher uma imagem
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    // Se uma imagem foi selecionada
    if (result != null) {
      // Atualiza o estado do widget com a imagem selecionada
      setState(() {
        selectedImageFile = result.files.first;
      });

      // Registra o caminho da imagem selecionada
      log('Imagem selecionada da galeria: ${selectedImageFile?.path}');
    } else {
      // Exibe uma notificação informando que nenhuma imagem foi selecionada
      Get.snackbar(
        'Ação Cancelada',
        'Você não selecionou nenhuma foto.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    }
  }

  // Função assíncrona para permitir que o usuário selecione uma imagem, seja através da câmera ou da galeria
  Future<void> pickImage() async {
    // Registra o início da execução da função
    log('Iniciando _pickImage...');

    // Exibe um diálogo modal
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Define o título do diálogo
        title: Text('Escolha uma opção'),

        // Conteúdo do diálogo com duas opções: Câmera e Galeria
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Opção para capturar imagem com a câmera
            ListTile(
              leading: Icon(CupertinoIcons.camera),
              title: Text('Câmera'),
              onTap: () {
                // Registra a seleção da opção Câmera
                log('Opção Câmera selecionada.');

                // Chama a função para obter imagem da câmera
                _getImageFromCamera();

                // Fecha o diálogo
                Navigator.of(context).pop();
              },
            ),

            // Opção para selecionar imagem da galeria
            ListTile(
              leading: Icon(CupertinoIcons.photo),
              title: Text('Galeria'),
              onTap: () {
                // Registra a seleção da opção Galeria
                log('Opção Galeria selecionada.');

                // Chama a função para obter imagem da galeria
                _getImageFromGallery();

                // Fecha o diálogo
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Função assíncrona que permite ao usuário selecionar um vídeo, seja capturando com a câmera ou escolhendo da galeria
  Future<void> pickVideo() async {
    // Exibe um diálogo para o usuário escolher uma opção
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Título do diálogo
        title: Text('Escolha uma opção'),

        // Conteúdo do diálogo apresentando duas opções: Câmera e Galeria
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Opção para capturar vídeo com a câmera
            ListTile(
              leading: Icon(CupertinoIcons.camera),
              title: Text('Câmera'),
              onTap: () {
                // Chama a função para capturar vídeo da câmera
                _getVideoFromCamera();

                // Fecha o diálogo
                Navigator.of(context).pop();
              },
            ),

            // Opção para selecionar imagem da galeria
            ListTile(
              leading: Icon(CupertinoIcons.photo),
              title: Text('Galeria'),
              onTap: () {
                // Chama a função para selecionar imagem da galeria
                _getImageFromGallery();

                // Fecha o diálogo
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  // Constrói o widget para a tela de 'Novo Chamado'
  Widget build(BuildContext context) {
     // Busca o controller do tema para verificar se o modo escuro está ativado
    final ThemeController themeController = Get.find();
    final isDark = themeController.isDarkMode.value;


    return WillPopScope(
      // Determina o comportamento quando o usuário tenta voltar
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          // Já lidamos com a ação de voltar.
          return false;
        }
        // Não permite fechar o app.
        return false;
      },
      child: Scaffold(
        // Define a barra superior da tela
        appBar: AppBar(
          title: Text(
            'Novo Chamado',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
          backgroundColor: isDark ? tDarkColor : whiteColor,
          elevation: 2,
        ),
        // Conteúdo principal da tela
        body: SingleChildScrollView(
          child: Container(
            // Estilos e aparência do container principal
            color: isDark ? tDarkColor : Colors.grey.withOpacity(.1),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Widget para a descrição do chamado
                InputDescription(description: description),
                Gap(12),
                // Widget para selecionar a categoria do chamado
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selecione a categoria:',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Gap(6),
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.categoryDescription),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ],
                ),
                // Se a categoria selecionada for 'outro', mostra mais campos
                if (_selectedCategory == Category.outro)
                  Column(
                    children: [
                      DefinicaoCategoria(
                        categoryController: definicaoCategoria,
                      ),
                      InputAddress(address: address),
                      InputAddressNumber(addressNumber: addressNumber),
                      InputZipCode(cep: cep),
                      InputReferPoint(referPoint: referPoint),
                      Gap(20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: pickImage,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(CupertinoIcons.camera_fill),
                                  Text('Enviar Foto'),
                                ],
                              ),
                            ),
                          ),
                          Gap(20),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: pickVideo,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(CupertinoIcons.videocam_fill),
                                  Text('Enviar Vídeo'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                // Se não for 'outro', mostra um conjunto diferente de campos
                else
                  Column(
                    children: [
                      InputAddress(address: address),
                      InputAddressNumber(addressNumber: addressNumber),
                      InputZipCode(cep: cep),
                      InputReferPoint(referPoint: referPoint),
                      Gap(20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: pickImage,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(CupertinoIcons.camera_fill),
                                  Text('Enviar Foto'),
                                ],
                              ),
                            ),
                          ),
                          Gap(20),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: pickVideo,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Icon(CupertinoIcons.videocam_fill),
                                  Text('Enviar Vídeo'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                Gap(20),
                // Botões para cancelar ou enviar o chamado
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar'),
                      ),
                    ),
                    Gap(20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          //! Se a função submitData retornar true, os dados são válidos
                          if (submitData()) {
                            //* Salva dentro de uma coleção chamados dentro
                            //* do documento do usuário logado/atual
                            ReportController().userAddNewReport(
                              address.text.trim(),
                              cep.text.trim(),
                              referPoint.text.trim(),
                              addressNumber.text.trim(),
                              description.text.trim(),
                              _selectedCategory,
                              definicaoCategoria.text.trim(),
                              imageFile: selectedImageFile!,
                              videoFile: selectedVideoFile,
                              isDone: false,
                            );
                            //* Salva direto na coleção Chamados
                            ReportController().addNewReportForAdmin(
                              address.text.trim(),
                              cep.text.trim(),
                              referPoint.text.trim(),
                              addressNumber.text.trim(),
                              description.text.trim(),
                              _selectedCategory,
                              definicaoCategoria.text.trim(),
                              imageFile: selectedImageFile!,
                              videoFile: selectedVideoFile,
                              isDone: false,
                            );
                            log(submitData().toString());
                            //? Isto irá fechar o formulário após a submissão bem-sucedida
                            Navigator.pop(context);
                          }
                          //! Se submitData retornar false, a função addNewReport não será chamada e o formulário não será fechado
                        },
                        child: Text('Enviar'),
                      ),
                    ),
                  ],
                ),
                Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
