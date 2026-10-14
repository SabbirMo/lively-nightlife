import 'package:get/get.dart';
import '../controller/club_profile_controller.dart';

class ClubProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubProfileController>(() => ClubProfileController());
  }
}
