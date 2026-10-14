import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/controllers/club_bottom_navbar_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_home_controller.dart';

class ClubBottomNavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClubBottomNavbarController>(() => ClubBottomNavbarController());
    Get.lazyPut<ClubHomeController>(() => ClubHomeController());
  }
}
