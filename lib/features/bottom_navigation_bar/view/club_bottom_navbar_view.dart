import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/controllers/club_bottom_navbar_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/widgets/custom_club_bottom_navbar.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/view/club_home_view.dart';

class ClubBottomNavbarView extends StatelessWidget {
  ClubBottomNavbarView({super.key});

  final controller = Get.find<ClubBottomNavbarController>();

  final pages = const [
    ClubHomeView(),
    Center(child: Text('Events')),
    Center(child: Text('Messages')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: pages,
        ),
      ),

      bottomNavigationBar: const CustomClubBottomNavbar(),
    );
  }
}
