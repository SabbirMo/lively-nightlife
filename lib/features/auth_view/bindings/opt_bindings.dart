import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/otp_controller.dart';


class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(
      () => OtpController(),
    );
  }
}