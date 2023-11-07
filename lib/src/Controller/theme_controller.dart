import 'package:get/get.dart';
import '../Utils/Theme/theme.dart';

// Classe controladora para gerenciar o tema da aplicação
class ThemeController extends GetxController {
  // Observável que determina se o modo escuro está ativado
  RxBool isDarkMode = false.obs;

  // Getter que retorna o valor atual de isDarkMode
  bool get currentTheme => isDarkMode.value;

  // Função para alternar entre o tema claro e escuro
  void toggleTheme() {
    // Inverte o valor de isDarkMode
    isDarkMode.value = !isDarkMode.value;
    
    // Altera o tema atual da aplicação
    Get.changeTheme(
      isDarkMode.value ? MyAppTheme.darkTheme : MyAppTheme.lightTheme,
    );
  }
}
