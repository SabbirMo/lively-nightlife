import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/controllers/user_bottom_navigation_bar_controller.dart';

class UserBottomNavbarBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserBottomNavbarController>(
      () => UserBottomNavbarController(),
    );
    // Get.lazyPut<FeedViewController>(() => FeedViewController(), fenix: true);
    // Get.put<WatchlistController>(WatchlistController(), permanent: true);
    // Get.put<ProfileController>(ProfileController(), permanent: true);
    // Get.put<EditProfileController>(EditProfileController(), permanent: true);
    // Get.lazyPut<CustomTabbarWidgetController>(() => CustomTabbarWidgetController());
    // Get.lazyPut<CustomFilterBottomSheetController>(() => CustomFilterBottomSheetController());
  }
}
