import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/password_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/reset_password_flow_controller.dart';

class ResetPasswordFlowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordFlowController>(
      () => ResetPasswordFlowController(),
      fenix: true,
    );
    Get.lazyPut<PasswordController>(
      () => PasswordController(),
      tag: 'createPassword',
      fenix: true,
    );
  }
}
