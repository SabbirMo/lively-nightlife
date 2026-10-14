import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/controller/user_chat_controller.dart';
import '../../user_discover_view/model/user_discover_club_model.dart';

class UserClubDetailsController extends GetxController {
  late final UserDiscoverClubModel club;

  // States
  final RxBool isFollowing = false.obs;
  final RxInt selectedSubTab =
      0.obs; // 0: About, 1: Events, 2: Gallery, 3: Reviews
  final RxString followersText = ''.obs;

  @override
  void onInit() {
    club = Get.arguments as UserDiscoverClubModel;
    followersText.value = club.followersCount;
    super.onInit();
  }

  void toggleFollow() {
    isFollowing.toggle();
    if (isFollowing.value) {
      if (club.followersCount.toLowerCase().endsWith('k')) {
        final doubleVal = double.tryParse(
          club.followersCount.substring(0, club.followersCount.length - 1),
        );
        if (doubleVal != null) {
          followersText.value = '${(doubleVal + 1).toInt()}k';
        } else {
          followersText.value = '893k';
        }
      } else {
        followersText.value = '893k';
      }
    } else {
      followersText.value = club.followersCount;
    }
  }

  void changeSubTab(int index) {
    selectedSubTab.value = index;
  }

  Future<void> shareExternally() async {
    await Share.share(
      'Check out ${club.name} on Lively! Location: ${club.location}',
    );
  }

  void shareInApp(String userName) {
    Get.back();
    if (Get.isRegistered<UserChatController>()) {
      Get.find<UserChatController>().shareClubOrEvent(userName, club);
    } else {
      final chatController = Get.put(UserChatController());
      chatController.shareClubOrEvent(userName, club);
    }

    Get.snackbar(
      'Shared Inside App',
      '${club.name} shared with $userName',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.blueColor,
      colorText: AppColors.whiteColor,
    );
  }
}
