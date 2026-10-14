import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_home_header.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_live_event_card.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_events_tab.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_analytics_tab.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_content_tab.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_overview_tab.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_tab_selector.dart';

class ClubHomeView extends GetView<ClubHomeController> {
  const ClubHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Image.asset(
            ImagePath.bluehighlightedBackground2,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ClubHomeHeader(),
                  SizedBox(height: 24.h),
                  const ClubLiveEventCard(),
                  SizedBox(height: 24.h),
                  const ClubTabSelector(),
                  SizedBox(height: 24.h),
                  Obx(() {
                    switch (controller.selectedTab.value) {
                      case 1:
                        return const ClubEventsTab();
                      case 2:
                        return const ClubAnalyticsTab();
                      case 3:
                        return const ClubContentTab();
                      default:
                        return const ClubOverviewTab();
                    }
                  }),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
