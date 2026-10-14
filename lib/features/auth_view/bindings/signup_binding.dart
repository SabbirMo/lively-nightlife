import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/auth_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}