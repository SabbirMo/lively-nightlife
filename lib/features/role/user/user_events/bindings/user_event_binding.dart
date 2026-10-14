import 'package:get/get.dart';
import '../controller/user_event_controller.dart';

class UserEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserEventController>(() => UserEventController());
  }
}
