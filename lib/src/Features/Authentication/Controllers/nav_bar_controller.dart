import 'package:get/get.dart';

class NavBarController extends GetxController {
  // Variável que armazena o índice da tab atualmente selecionada.
  var tabIndex = 0;

  // Função que altera o valor de tabIndex para o índice fornecido.
  void chanegTabIndex(int index) {
    tabIndex = index;
    // Chama o método `update()` para notificar os ouvintes sobre a mudança.
    update();
  }
}
