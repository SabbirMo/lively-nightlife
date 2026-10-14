import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_club_details_controller.dart';
import '../widget/user_club_details_about_tab.dart';
import '../widget/user_club_details_events_tab.dart';
import '../widget/user_club_details_gallery_tab.dart';
import '../widget/user_club_details_header_widget.dart';
import '../widget/user_club_details_reviews_tab.dart';
import '../widget/user_club_details_stats_widget.dart';

class UserClubDetailsView extends GetView<UserClubDetailsController> {
  const UserClubDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final club = controller.club;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Stack (Cover Image + Navigation Bar + Overlapping profile controls)
            UserClubDetailsHeaderWidget(controller: controller),

            SizedBox(
              height: 16.h,
            ), // Margin to offset the overlapping avatar block
            // Club Name, Rating, Categories section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextProperty(
                          text: club.name,
                          textColor: AppColors.blackColor,
                          fontFamily: 'Sora',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Rating pill
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16.sp,
                            color: AppColors.amberColor,
                          ),
                          SizedBox(width: 4.w),
                          TextProperty(
                            text: club.rating.toString(),
                            textColor: AppColors.amberColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Location & Price
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: AppColors.lightGreyColor,
                      ),
                      SizedBox(width: 4.w),
                      TextProperty(
                        text: '${club.location} · ${club.priceRange}',
                        textColor: AppColors.lightGreyColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Category Pills
                  Wrap(
                    spacing: 8.w,
                    children: club.categories.map((cat) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blueColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: TextProperty(
                          text: cat,
                          textColor: AppColors.blueColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),

                  // Stats Panel (Cards + Progress Bar)
                  UserClubDetailsStatsWidget(controller: controller),

                  SizedBox(height: 24.h),

                  // Custom Gradient Sub-Tabs Bar
                  _buildSubTabBar(),

                  SizedBox(height: 20.h),

                  // Dynamic Tab Content View
                  Obx(() {
                    switch (controller.selectedSubTab.value) {
                      case 1:
                        return const UserClubDetailsEventsTab();
                      case 2:
                        return const UserClubDetailsGalleryTab();
                      case 3:
                        return const UserClubDetailsReviewsTab();
                      default:
                        return const UserClubDetailsAboutTab();
                    }
                  }),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTabBar() {
    final tabs = ['About', 'Events', 'Gallery', 'Reviews'];

    return Obx(() {
      return Container(
        height: 42.h,
        decoration: BoxDecoration(
          color: AppColors.grey50Color.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: AppColors.grey50Color.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = controller.selectedSubTab.value == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changeSubTab(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: isSelected
                      ? BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.gradientStartColor,
                              AppColors.gradientMiddleColor,
                              AppColors.gradientEndColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(100.r),
                        )
                      : null,
                  child: TextProperty(
                    text: tabs[index],
                    textColor: isSelected
                        ? AppColors.whiteColor
                        : AppColors.lightGreyColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
