// import 'dart:developer';
// import 'package:easy_stepper/easy_stepper.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:the_safe_city/src/Features/Core/Category/provider/firestore_provider.dart';

// import '../../../../../Constants/colors.dart';
// import '../../../../../Controller/theme_controller.dart';
// import '../../Controller/chamados_controller.dart';
// import '../../model/chamados_model.dart';
// import '../Widgets/display_message.dart';
// import '../Widgets/input_admin_message.dart';

// class EditReportFormScreen extends StatefulWidget {
//   const EditReportFormScreen({super.key, required this.reportId});
//   final String reportId;

//   @override
//   State<EditReportFormScreen> createState() => _EditReportFormScreenState();
// }

// class _EditReportFormScreenState extends State<EditReportFormScreen> {
//   final description = TextEditingController();
//   final categoryController = TextEditingController();
//   final address = TextEditingController();
//   final addressNumber = TextEditingController();
//   final category = TextEditingController();
//   final cep = TextEditingController();
//   final referPoint = TextEditingController();
//   final adminMessage = TextEditingController();

//   // --------------------------------------
//   String statusMessage = 'Enviado';
//   int activeStep = 3;
//   List<String> statusMessageList = [
//     "Enviado",
//     "Em andamento",
//     "Encerrado",
//     "Cancelado"
//   ];

//     String _selectedCategory = '';
//   List<String> _categories = [];

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   bool showMessage = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadReportData();

//   }

//   Future<void> _loadCategories() async {
//     List<String> categories =
//         await FirestoreProvider.getDocuments('categories');
//     setState(() {
//       _categories = categories;
//       _selectedCategory = _categories.isNotEmpty
//           ? _categories[0]
//           : ''; // Define o primeiro item como o valor inicial
//     });
//   }
  
//   // Atualiza a opção de exibir ou não a mensagem quando alterada.
//   void _handleDisplayMessageChanged(bool newValue) {
//     setState(() {
//       showMessage = newValue;
//     });
//     ReportController().updateDisplayMessage(widget.reportId, newValue);
//   }

//   //@ Verifica se todos os campos foram preenchidos corretamente.
//   bool submitData() {
//     if (address.text.trim().isEmpty &&
//         cep.text.trim().isEmpty &&
//         referPoint.text.trim().isEmpty &&
//         addressNumber.text.trim().isEmpty &&
//         description.text.trim().isEmpty) {
//       // Exibe uma mensagem de erro se algum campo não for preenchido.
//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: const Text('Dados Inválidos'),
//           content: const Text(
//             'Por favor, verifique se os dados foram preenchidos e/ou atualizados corretamente.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(ctx);
//               },
//               child: const Text('Okay'),
//             ),
//           ],
//         ),
//       );
//       return false;
//     }
//     return true;
//   }

//   // Carrega os dados do relatório a partir de seu ID.
//   Future<void> _loadReportData() async {
//     // Obtém os dados do relatório usando seu ID.
//     ReportingModel? report =
//         await ReportController().getReportById(widget.reportId);

//     if (report != null) {
//       // Se os dados do relatório foram encontrados, atualiza os controladores de texto.
//       setState(() {
//         address.text = report.address;
//         cep.text = report.cep;
//         referPoint.text = report.referPoint;
//         addressNumber.text = report.addressNumber;
//         description.text = report.description;
//         categoryController.text = report.definicaoCategoria;
//         category.text = report.category;
//         adminMessage.text = report.messageString;
//         showMessage = report.showMessage;
//         statusMessage = report.statusMessage.toString();
//       });
//     }
//     log('Categoria carregada: ${report?.category}');
//   }

//   // Carrega o ID do usuário associado ao relatório.
//   Future<String> _loadUserId() async {
//     try {
//       // Obtém os dados do relatório usando seu ID.
//       ReportingModel? report =
//           await ReportController().getReportById(widget.reportId);
//       if (report != null) {
//         return report.userId;
//       }
//     } catch (error) {
//       log("Erro ao carregar os dados: $error");
//       // Exibe um snack bar com mensagem de erro.
//       Get.snackbar('Erro', 'Não foi possível atualizar os dados');
//     }
//     return '';
//   }

//   void _updateReport() async {
//     if (submitData()) {
//       // Obtém o ID do usuário associado ao relatório.
//       String userId = await _loadUserId();

//       // Cria um novo objeto `ReportingModel` com os dados atualizados.
//       final updatedReport = ReportingModel(
//         chamadoId: widget.reportId,
//         userId: userId,
//         isDone: false,
//         address: address.text.trim(),
//         cep: cep.text.trim(),
//         addressNumber: addressNumber.text.trim(),
//         referPoint: referPoint.text.trim(),
//         description: description.text.trim(),
//         category: category.text.trim(),
//         definicaoCategoria: categoryController.text.trim(),
//         date: currentDate,
//         statusMessage: statusMessage.trim(),
//         showMessage: showMessage,
//         messageString: adminMessage.text.trim(),
//       );

//       // Usa o controlador para atualizar o relatório no banco de dados.
//       ReportController().updateReport(widget.reportId, updatedReport);

//       // Fecha o formulário após a atualização bem-sucedida.
//       Navigator.of(_scaffoldKey.currentContext!).pop();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _loadUserId();
    
//     final ThemeController themeController = Get.find();
//     final isDark = themeController.isDarkMode.value;

//     return Scaffold(
//       key: _scaffoldKey, // Define uma chave para o Scaffold.
//       appBar: AppBar(
//         title: Text(
//           'Editar chamado',
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.displayLarge,
//         ),
//         centerTitle: true,
//         backgroundColor: isDark ? tDarkColor : whiteColor,
//         elevation: 2,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(1.0),
//         child: Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 15,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               EasyStepper(
//                 activeStep: activeStep,
//                 padding: const EdgeInsetsDirectional.symmetric(
//                   horizontal: 30,
//                   vertical: 20,
//                 ),
//                 internalPadding: 0,
//                 activeStepTextColor: Colors.green,
//                 activeStepBackgroundColor: Colors.green,
//                 activeStepIconColor: Colors.green,
//                 finishedStepTextColor: Colors.black87,
//                 finishedStepBackgroundColor: Colors.white,
//                 disableScroll: true,
//                 showLoadingAnimation: false,
//                 stepRadius: 15,
//                 lineStyle: const LineStyle(
//                   lineLength: 70,
//                   lineType: LineType.normal,
//                   defaultLineColor: Colors.grey,
//                   finishedLineColor: Colors.green,
//                 ),
//                 steps: List.generate(
//                     statusMessageList.length,
//                     (index) => EasyStep(
//                           customStep: CircleAvatar(
//                             radius: 8,
//                             backgroundColor: Colors.white,
//                             child: CircleAvatar(
//                               radius: 7,
//                               backgroundColor: activeStep >= index
//                                   ? activeStep == statusMessageList.length
//                                       ? Colors.red
//                                       : Colors.green
//                                   : Colors.grey,
//                             ),
//                           ),
//                           title: statusMessageList[index],
//                         )),
//               ),

//               //InputStatusMessage(statusMessage: statusMessage),
//               Gap(6),
//               Text(
//                 'Status do chamado:',
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),
//               Gap(6),
//               DropdownButton(
//                 value: statusMessage,
//                 items: statusMessageList.map((String value) {
//                   return DropdownMenuItem(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? value) {
//                   setState(() {
//                     statusMessage = value!;
//                     activeStep = statusMessageList.indexOf(statusMessage);
//                   });
//                 },
//               ),

//               DisplayMessageDropdown(
//                 showMessage,
//                 _handleDisplayMessageChanged,
//               ),
//               InputAdminMessage(adminMessage: adminMessage),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
