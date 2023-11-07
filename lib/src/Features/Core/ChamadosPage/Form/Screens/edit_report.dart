// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../Constants/colors.dart';
import '../../../../../Controller/theme_controller.dart';
import '../../Controller/chamados_controller.dart';
import '../../model/chamados_model.dart';
import '../Widgets/definicao_da_categoria.dart';
import '../Widgets/display_message.dart';
import '../Widgets/input_address.dart';
import '../Widgets/input_admin_message.dart';
import '../Widgets/input_description.dart';
import '../Widgets/input_address_number.dart';
import '../Widgets/input_refer_point.dart';
import '../Widgets/input_status_message.dart';
import '../Widgets/input_zip_code.dart';

class EditReportFormScreen extends StatefulWidget {
  const EditReportFormScreen({super.key, required this.reportId});
  final String reportId;

  @override
  State<EditReportFormScreen> createState() => _EditReportFormScreenState();
}

class _EditReportFormScreenState extends State<EditReportFormScreen> {
  // Inicializa os controladores de texto para os campos do formulário.
  final description = TextEditingController();
  final categoryController = TextEditingController();
  final address = TextEditingController();
  final addressNumber = TextEditingController();
  final cep = TextEditingController();
  final referPoint = TextEditingController();
  final statusMessage = TextEditingController();
  final adminMessage = TextEditingController();

  Category _selectedCategory = Category.buracoRua;

  final ReportController _reportController = ReportController();

  // Chave para associar ao Scaffold e permitir o acesso a funcionalidades específicas.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Variável que determina se a mensagem do administrador deve ser exibida ou não.
  bool showMessage = false;

  // Carrega os dados do relatório assim que o widget é inicializado.
  Future<void>? _loadReportDataFuture;

  // Atualiza a opção de exibir ou não a mensagem quando alterada.
  void _handleDisplayMessageChanged(bool newValue) {
    setState(() {
      showMessage = newValue;
    });
    _reportController.updateDisplayMessage(widget.reportId, newValue);
  }

  //@ Verifica se todos os campos foram preenchidos corretamente.
  bool submitData() {
    if (address.text.trim().isEmpty &&
        cep.text.trim().isEmpty &&
        referPoint.text.trim().isEmpty &&
        addressNumber.text.trim().isEmpty &&
        description.text.trim().isEmpty) {
      // Exibe uma mensagem de erro se algum campo não for preenchido.
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Dados Inválidos'),
          content: const Text(
            'Por favor, verifique se os dados foram preenchidos e/ou atualizados corretamente.',
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
    return true;
  }

  @override
  void initState() {
    super.initState();
    // Inicializa a tarefa de carregar os dados do relatório.
    _loadReportDataFuture = _loadReportData();
  }

  // Carrega os dados do relatório a partir de seu ID.
  Future<void> _loadReportData() async {
    try {
      // Obtém os dados do relatório usando seu ID.
      ReportingModel? report =
          await _reportController.getReportById(widget.reportId);

      if (report != null) {
        // Se os dados do relatório foram encontrados, atualiza os controladores de texto.
        setState(() {
          address.text = report.address;
          cep.text = report.cep;
          referPoint.text = report.referPoint;
          addressNumber.text = report.addressNumber;
          description.text = report.description;
          categoryController.text = report.definicaoCategoria;
          _selectedCategory = report.category;
          adminMessage.text = report.messageString;
          showMessage = report.showMessage;
          statusMessage.text = report.statusMessage.toString();
        });
      }
      log('Categoria carregada: ${report?.category}');
    } catch (error) {
      log("Erro ao carregar os dados: $error");
      // Exibe um snack bar com mensagem de erro.
      Get.snackbar('Erro', 'Não foi possível atualizar os dados');
    }
  }

  // Carrega o ID do usuário associado ao relatório.
  Future<String> _loadUserId() async {
    try {
      // Obtém os dados do relatório usando seu ID.
      ReportingModel? report =
          await _reportController.getReportById(widget.reportId);
      if (report != null) {
        return report.userId;
      }
    } catch (error) {
      log("Erro ao carregar os dados: $error");
      // Exibe um snack bar com mensagem de erro.
      Get.snackbar('Erro', 'Não foi possível atualizar os dados');
    }
    return '';
  }

  void _updateReport() async {
    if (submitData()) {
      // Obtém o ID do usuário associado ao relatório.
      String userId = await _loadUserId();
      
      // Cria um novo objeto `ReportingModel` com os dados atualizados.
      final updatedReport = ReportingModel(
        chamadoId: widget.reportId,
        userId: userId,
        isDone: false,
        address: address.text.trim(),
        cep: cep.text.trim(),
        addressNumber: addressNumber.text.trim(),
        referPoint: referPoint.text.trim(),
        description: description.text.trim(),
        category: _selectedCategory,
        definicaoCategoria: categoryController.text.trim(),
        date: currentDate,
        statusMessage: statusMessage.text.trim(),
        showMessage: showMessage,
        messageString: adminMessage.text.trim(),
      );

      // Usa o controlador para atualizar o relatório no banco de dados.
      _reportController.updateReport(widget.reportId, updatedReport);

      // Fecha o formulário após a atualização bem-sucedida.
      Navigator.of(_scaffoldKey.currentContext!).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtém uma instância do controlador de tema.
  final ThemeController themeController = Get.find();
  
  // Verifica se o modo escuro está ativado.
  final isDark = themeController.isDarkMode.value;

  return FutureBuilder<void>(
    future: _loadReportDataFuture, 
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Se os dados do relatório ainda estão sendo carregados, exibe um indicador de carregamento.
        return Center(child: CircularProgressIndicator());
      }
      
      // Estrutura geral da tela de edição de relatório.
      return WillPopScope(
        onWillPop: () async {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            return false;
          }
          // Não permite fechar o app.
          return false;
        },
        child: Scaffold(
          key: _scaffoldKey, // Define uma chave para o Scaffold.
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
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Widgets que compõem a tela, como campos de entrada e botões.
                  InputDescription(description: description),
                  Gap(12),
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
                    if (_selectedCategory == Category.outro)
                      SizedBox(
                        child: Column(
                          children: [
                            DefinicaoCategoria(
                              categoryController: categoryController,
                            ),
                            InputAddress(address: address),
                            InputAddressNumber(addressNumber: addressNumber),
                            InputZipCode(cep: cep),
                            InputReferPoint(referPoint: referPoint),
                            InputStatusMessage(statusMessage: statusMessage),
                            DisplayMessageDropdown(
                              showMessage,
                              _handleDisplayMessageChanged,
                            ),
                            InputAdminMessage(adminMessage: adminMessage),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: [
                          InputAddress(address: address),
                          InputAddressNumber(addressNumber: addressNumber),
                          InputZipCode(cep: cep),
                          InputReferPoint(referPoint: referPoint),
                          InputStatusMessage(statusMessage: statusMessage),
                          DisplayMessageDropdown(
                            showMessage,
                            _handleDisplayMessageChanged,
                          ),
                          InputAdminMessage(adminMessage: adminMessage),
                        ],
                      ),
                    Gap(20),
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
                            onPressed: _updateReport,
                            child: Text('Editar Dados'),
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
      },
    );
  }
}
