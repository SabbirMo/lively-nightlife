import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_other_profile_controller.dart';
import '../widget/user_other_profile_header.dart';
import '../widget/user_other_profile_info.dart';
import '../widget/user_other_profile_tab_bar.dart';
import '../widget/user_other_profile_post_grid.dart';
import '../widget/user_other_profile_event_list.dart';

class UserOtherProfileView extends StatelessWidget {
  const UserOtherProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserOtherProfileController());

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section (Cover photo, Nav & Action Buttons)
            const UserOtherProfileHeader(),
            SizedBox(height: 52.h),

            // Profile Bio, Details & Stats Cards Section
            const UserOtherProfileInfo(),
            SizedBox(height: 24.h),

            // Tabs Selector (Grid, Star/Events)
            const UserOtherProfileTabBar(),
            SizedBox(height: 16.h),

            // Tab Content Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Obx(() {
                final activeTab = controller.selectedTab.value;
                if (activeTab == 0) {
                  return const UserOtherProfilePostGrid();
                } else {
                  return const UserOtherProfileEventList();
                }
              }),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
