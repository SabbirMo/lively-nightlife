import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_endpoints.dart';
import 'package:lively_nightlife_nightclub_party/core/services/api_service.dart';
import 'package:lively_nightlife_nightclub_party/core/services/token_storage_service.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_profile_setting/model/user_profile_model.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class UserProfileSettingController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observable Profile State
  final Rx<UserProfileModel?> userProfile = Rx<UserProfileModel?>(null);
  final RxBool isLoadingProfile = false.obs;
  final RxString profileErrorMessage = ''.obs;

  // Profile Info Getters
  String get name {
    final first = userProfile.value?.firstName?.trim() ?? '';
    final last = userProfile.value?.lastName?.trim() ?? '';
    final full = '$first $last'.trim();
    if (full.isNotEmpty) return full;
    return userProfile.value?.username ?? 'User';
  }

  String get username {
    final u = userProfile.value?.username?.trim() ?? '';
    if (u.isEmpty) return '';
    return u.startsWith('@') ? u : '@$u';
  }

  String get email => userProfile.value?.email ?? '';
  String get password => '••••••••';
  String get purchaseHistory =>
      '${userProfile.value?.eventsCount ?? 0} tickets';
  String? get profileImageUrl => userProfile.value?.profileImage;

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

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// Fetches the user profile from /api/users/profile/
  Future<void> fetchUserProfile() async {
    try {
      isLoadingProfile.value = true;
      profileErrorMessage.value = '';

      final response = await _apiService.get(
        ApiEndpoints.userProfile,
        requireAuth: true,
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          userProfile.value = UserProfileModel.fromJson(response.data);
        }
      }
    } catch (e) {
      profileErrorMessage.value = e.toString();
    } finally {
      isLoadingProfile.value = false;
    }
  }

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
