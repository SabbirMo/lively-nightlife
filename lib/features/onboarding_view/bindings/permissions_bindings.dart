import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/controller/permissions_controller.dart';


class PermissionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionsController>(() => PermissionsController());
  }
}
