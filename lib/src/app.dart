import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// Importações de controladores, temas e bindings
import 'Controller/theme_controller.dart';
import 'Utils/Theme/theme.dart';
import 'Utils/app_bindings.dart';

class MyApp extends StatelessWidget {
  // Construtor que aceita uma chave
  MyApp({super.key});

  // Inicializa e armazena o controlador de tema no GetX
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    // Obtém a instância do controlador de tema do GetX
    final ThemeController themeController = Get.find();
    
    // Verifica se o modo escuro está ativado
    final isDark = themeController.isDarkMode.value;

    // Define a orientação preferida do dispositivo para retrato
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // Constrói o aplicativo principal com temas claro e escuro
    return GetMaterialApp(
      // Inicializa os bindings
      initialBinding: InitialBinding(),
      
      // Define os temas claro e escuro
      theme: MyAppTheme.lightTheme,
      darkTheme: MyAppTheme.darkTheme,
      
      // Define o modo de tema com base no valor de isDark
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      
      // Desativa o banner de modo de depuração
      debugShowCheckedModeBanner: false,
      
      // Define a tela inicial como um indicador de progresso
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
