import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/controller/user_discover_controller.dart';

class UserDiscoverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserDiscoverController>(() => UserDiscoverController());
  }
}
