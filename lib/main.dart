import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
//* Classes importadas
import 'src/Repository/AuthenticationRepository/authentication_repository.dart';
import 'src/firebase_options.dart';
import 'src/app.dart';

Future<void> main() async {
  // Garante a inicialização do binding de widgets do Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as opções padrão para a plataforma atual e coloca o `AuthenticationRepository` no GetX para gerenciamento de estado
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (_) => Get.put(
      AuthenticationRepository(),
    ),
  );

  // Carrega variáveis de ambiente usando FlutterConfig
  await FlutterConfig.loadEnvVariables();

  // Configura um manipulador global de erros para registrar exceções no Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    log(details.exception.toString());
    log(details.stack.toString());
  };

  // Inicia o aplicativo
  runApp(MyApp());
}
