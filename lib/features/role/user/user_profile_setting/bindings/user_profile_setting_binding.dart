import 'package:get/get.dart';
import '../controller/user_profile_setting_controller.dart';

class UserProfileSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProfileSettingController>(() => UserProfileSettingController());
  }
}
