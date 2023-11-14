import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:the_safe_city/src/Features/Core/ChamadosPage/Controller/chamados_controller.dart';
import 'package:the_safe_city/src/Features/Core/ChamadosPage/model/chamados_model.dart';
import 'package:the_safe_city/src/Utils/Widgets/input_text_field.dart';

class EditReportFormScreenNew extends StatefulWidget {
  const EditReportFormScreenNew({super.key, this.documentData});
  final dynamic documentData;

  @override
  State<EditReportFormScreenNew> createState() =>
      _EditReportFormScreenNewState();
}

class _EditReportFormScreenNewState extends State<EditReportFormScreenNew> {
  final observation = TextEditingController();
  final key_sccaffold = GlobalKey();

  bool submitData() {
    if (observation.text.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Dados Inválidos'),
          content: const Text(
            'Por favor, adicione uma observação no chamado.',
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

  void _updateReport() async {
    if (submitData()) {
      final updatedReport = ReportingModel(
        chamadoId: widget.documentData["Id do Chamado"],
        userId: widget.documentData["Id do Usuario"],
        isDone: false,
        address: widget.documentData["Endereco-Local"],
        cep: widget.documentData["CEP"],
        addressNumber: widget.documentData["Numero do Endereco"],
        referPoint: widget.documentData["Ponto de Referencia"],
        description: widget.documentData["Descricao"],
        category: widget.documentData["Categoria"],
        definicaoCategoria: widget.documentData["Categoria do chamado"],
        date: currentDate,
        statusMessage: widget.documentData["Status do chamado"],
        showMessage: widget.documentData["Exibir Mensagem"],
        messageString: widget.documentData["Mensagem do Admin"],
      );

      ReportController()
          .updateReport(widget.documentData["Id do Chamado"], updatedReport);

      Navigator.of(key_sccaffold.currentContext!).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> statusMessageList = [
      "Enviado",
      "Em andamento",
      "Encerrado",
      "Cancelado"
    ];
    dynamic activeStep = statusMessageList
        .indexOf(widget.documentData["Status do chamado"].toString());

    return Scaffold(
      key: key_sccaffold,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Editar chamado',
            style: Theme.of(context).textTheme.displayLarge),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5,
        //shadow
        titleSpacing: 10,
        //space between leading icon and title
      ),
      body: Container(
        color: Colors.grey.withOpacity(.1),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      )),
            ),
            const Gap(20),
            Text(
              'Status do chamado:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            DropdownButton(
              value: widget.documentData["Status do chamado"].toString(),
              items: statusMessageList.map((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  widget.documentData["Status do chamado"] = value!;
                  activeStep = statusMessageList.indexOf(
                      widget.documentData["Status do chamado"].toString());
                });
              },
            ),
            const Gap(20),
            Text(
              'Observação:',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            InputTextField(
              controller: observation,
              keyBoardType: TextInputType.text,
              hintText: 'Observação',
              maxLines: 3,
              obscureText: false,
              onValidator: (value) {
                return null;
              },
            ),
            const Gap(20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(5.0),
                  minimumSize: const Size(100, 20),
                  elevation: 5,
                ),
                onPressed: () {
                  _updateReport();
                },
                child: Text(
                  "Editar",
                  style: Theme.of(context).textTheme.headlineMedium,
                ))
          ],
        ),
      ),
    );
  }
}
