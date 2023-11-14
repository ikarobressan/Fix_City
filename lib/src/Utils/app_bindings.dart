import 'package:get/get.dart';

import '../Features/Authentication/Controllers/login_controller.dart';
import '../Features/Authentication/Controllers/otp_controller.dart';
import '../Features/Authentication/Controllers/signup_controller.dart';
import '../Features/Core/ChamadosPage/Controller/chamados_controller.dart';
import '../Features/Core/ChamadosPage/Controller/user_controller.dart';
import '../Features/Core/NavBar/navigation_bar.dart';
import '../Repository/AuthenticationRepository/authentication_repository.dart';
import '../Repository/UserRepository/user_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationRepository(), fenix: true);
    Get.lazyPut(() => UserRepository(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => ReportController(), fenix: true);
    Get.lazyPut(() => const MyNavigationBar(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => OTPController(), fenix: true);
  }
}
