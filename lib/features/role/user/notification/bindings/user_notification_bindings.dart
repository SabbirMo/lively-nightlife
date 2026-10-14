import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/controller/user_notification_controller.dart';

class UserNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserNotificationController>(() => UserNotificationController());
  }
}
