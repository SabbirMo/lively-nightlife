import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/token_storage_service.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class UserProfileSettingController extends GetxController {
  // Profile Info
  final String name = 'Alex Rivera';
  final String username = '@alex_nights';
  final String email = 'alex@nightlife.app';
  final String password = '••••••••';
  final String purchaseHistory = '12 tickets';
  final String profileImageUrl = 'https://i.pravatar.cc/150?img=10';

  // Notification Toggles (Social)
  final likes = true.obs;
  final comments = true.obs;
  final newFollowers = true.obs;
  final messages = true.obs;

  // Notification Toggles (Activity)
  final eventsAndRSVPs = true.obs;
  final heatMapAlerts = true.obs;

  // Notification Toggles (Other)
  final promotions = false.obs;
  final smsNotifications = false.obs;

  // Toggle Methods
  void toggleLikes(bool value) => likes.value = value;
  void toggleComments(bool value) => comments.value = value;
  void toggleNewFollowers(bool value) => newFollowers.value = value;
  void toggleMessages(bool value) => messages.value = value;
  void toggleEventsAndRSVPs(bool value) => eventsAndRSVPs.value = value;
  void toggleHeatMapAlerts(bool value) => heatMapAlerts.value = value;
  void togglePromotions(bool value) => promotions.value = value;
  void toggleSmsNotifications(bool value) => smsNotifications.value = value;

  // Switch to Club flow
  void switchRoleToClub() {
    Get.offAllNamed(AppRoute.clubBottomNavbarView);
  }

  // Logout/Delete account methods
  Future<void> logout() async {
    await TokenStorageService.logout();
  }

  Future<void> deleteAccount() async {
    await TokenStorageService.logout();
  }
}
