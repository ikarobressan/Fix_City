import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StepWidget extends StatelessWidget {
  final String? statusMessage;
  final dynamic data;
  final String obs;

  const StepWidget(
      {super.key,
      required this.statusMessage,
      required this.data,
      required this.obs});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> statusList = {
      "Enviado": const Icon(Icons.double_arrow_rounded,
          color: Colors.blue, size: 35.8),
      "Em andamento": const Icon(Icons.rocket_launch,
          color: Colors.orangeAccent, size: 35.8),
      "Encerrado": const Icon(Icons.task_alt, color: Colors.green, size: 35.8),
      "Cancelado": const Icon(Icons.cancel_presentation_rounded,
          color: Colors.red, size: 35.8),
    };

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          statusList[statusMessage],
          const Gap(20),
          Column(
            children: [
              Text(data.toDate().toString()),
              Text(obs),
            ],
          )
        ],
      ),
    );
  }
}
