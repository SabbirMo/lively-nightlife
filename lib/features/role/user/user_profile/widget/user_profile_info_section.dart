import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_profile_controller.dart';
import 'user_profile_stats_card.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class UserProfileInfoSection extends StatelessWidget {
  const UserProfileInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserProfileController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextProperty(
          text: 'Alex Rivera',
          textColor: AppColors.blackColor,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 2.h),
        TextProperty(
          text: '@alex_nights',
          textColor: AppColors.lightGreyColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 12.h),
        TextProperty(
          text: '🎉 Nightlife enthusiast | Club hopper | EDM lover',
          textColor: AppColors.secondBlackColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 4.h),
        TextProperty(
          text: '📍 Los Angeles, CA | Party every weekend',
          textColor: AppColors.secondBlackColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppColors.lightGreyColor,
              size: 16.sp,
            ),
            SizedBox(width: 4.w),
            TextProperty(
              text: 'Los Angeles, CA',
              textColor: AppColors.lightGreyColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: UserProfileStatsCard(
                  value: controller.postsCount,
                  label: 'Posts',
                  valueColor: AppColors.insaneColor,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoute.userFollowersView),
                  child: UserProfileStatsCard(
                    value: controller.followersCount,
                    label: 'Followers',
                    valueColor: AppColors.blueColor,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoute.userFollowingView),
                  child: UserProfileStatsCard(
                    value: controller.followingCount,
                    label: 'Following',
                    valueColor: AppColors.blueColor,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: UserProfileStatsCard(
                  value: controller.eventsCount,
                  label: 'Events',
                  valueColor: AppColors.redColor,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
