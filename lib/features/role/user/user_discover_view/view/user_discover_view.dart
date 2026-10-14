import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/controller/user_discover_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/widget/user_discover_club_card_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/widget/user_discover_header_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/widget/user_discover_tab_bar_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/widget/user_discover_trending_card_widget.dart';

class UserDiscoverView extends StatelessWidget {
  const UserDiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserDiscoverController());
    return Scaffold(
      body: Stack(
        children: [
          // Blue Highlighted Background
          Image.asset(
            ImagePath.bluehighlightedBackground,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (Logo, Bell, Search, Filter icon)
                  UserDiscoverHeaderWidget(controller: controller),

                  SizedBox(height: 24.h),

                  // Horizontal Category Tab Chips
                  UserDiscoverTabBarWidget(controller: controller),

                  SizedBox(height: 20.h),

                  // Trending Promo Card (Only shown in 'All' tab)
                  Obx(() {
                    if (controller.selectedTab.value == 0) {
                      return Column(
                        children: [
                          const UserDiscoverTrendingCardWidget(),
                          SizedBox(height: 20.h),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  // Dynamic Filtered List
                  Obx(
                    () => ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 100.h),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.filteredClubs.length,
                      itemBuilder: (context, index) {
                        final club = controller.filteredClubs[index];
                        return UserDiscoverClubCardWidget(
                          club: club,
                          onTap: () => controller.onClubTap(club),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
