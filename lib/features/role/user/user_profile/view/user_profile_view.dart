import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_profile_controller.dart';
import '../widget/user_profile_header_widget.dart';
import '../widget/user_profile_info_section.dart';
import '../widget/user_profile_tab_bar.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/widget/feed_post_card_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/widget/user_event_list_card.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserProfileController());

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      floatingActionButton: CustomButton(
        text: 'Add Post',
        icon: Icons.add,
        color: AppColors.blueColor,
        borderColor: Colors.transparent,
        borderRadius: BorderRadius.circular(100.r),
        textColor: AppColors.whiteColor,
        buttonWidth: 130.w,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        onTap: () => controller.addMockPost(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Faded Cover Photo Header Widget
            const UserProfileHeaderWidget(),
            SizedBox(height: 16.h),

            // Profile info and details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Biography & Stats Section Widget
                  const UserProfileInfoSection(),
                  SizedBox(height: 24.h),

                  // Pill Tabbar Widget
                  const UserProfileTabBar(),
                  SizedBox(height: 16.h),

                  // Grid / Tab Content Section
                  Obx(() {
                    final activeTab = controller.selectedTab.value;

                    if (activeTab == 0) {
                      final posts = controller.postsList;
                      if (posts.isEmpty) {
                        return SizedBox(
                          height: 150.h,
                          child: Center(
                            child: TextProperty(
                              text: 'No posts available',
                              textColor: AppColors.lightGreyColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: posts.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.w,
                          mainAxisSpacing: 8.h,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Image.network(
                              posts[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    } else if (activeTab == 1) {
                      final saved = controller.savedPosts;
                      if (saved.isEmpty) {
                        return SizedBox(
                          height: 150.h,
                          child: Center(
                            child: TextProperty(
                              text: 'No saved posts',
                              textColor: AppColors.lightGreyColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: saved.length,
                        itemBuilder: (context, index) {
                          return FeedPostCardWidget(post: saved[index]);
                        },
                      );
                    } else {
                      final rsvped = controller.rsvpedEvents;
                      if (rsvped.isEmpty) {
                        return SizedBox(
                          height: 150.h,
                          child: Center(
                            child: TextProperty(
                              text: 'No RSVP\'d events',
                              textColor: AppColors.lightGreyColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: rsvped.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final event = rsvped[index];
                          return UserEventListCard(
                            event: event,
                            onTap: () => Get.toNamed(
                              AppRoute.userEventDetailsView,
                              arguments: event,
                            ),
                          );
                        },
                      );
                    }
                  }),
                  SizedBox(height: 100.h), // Spacing for floating button
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
