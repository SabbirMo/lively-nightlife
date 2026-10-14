import 'package:get/get.dart';
import '../controller/user_club_details_controller.dart';

class UserClubDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserClubDetailsController>(() => UserClubDetailsController());
  }
}
