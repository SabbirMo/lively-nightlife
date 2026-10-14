import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/controllers/user_bottom_navigation_bar_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/widgets/custom_user_bottom_navbar.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/view/user_discover_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/view/user_home_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/view/user_chat_inbox_view.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/view/user_event_list_view.dart';

class UserBottomNavigationView extends StatelessWidget {
  UserBottomNavigationView({super.key});

  final controller = Get.find<UserBottomNavbarController>();

  final pages = [
    UserHomeView(),
    const UserDiscoverView(),
    const Center(child: Text('Location')),
    const UserEventListView(),
    const UserChatInboxView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.selectedIndex.value]),

      bottomNavigationBar: Obx(
        () => controller.selectedIndex.value == 4
            ? const SizedBox.shrink()
            : const CustomUserBottomNavbar(),
      ),
    );
  }
}
