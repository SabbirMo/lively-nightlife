import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import '../controller/user_other_profile_controller.dart';
import 'user_profile_stats_card.dart';

class UserOtherProfileInfo extends StatelessWidget {
  const UserOtherProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserOtherProfileController>();
    final user = controller.user;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextProperty(
            text: user.name,
            textColor: AppColors.blackColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 2.h),
          TextProperty(
            text: user.username,
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

          // User Statistics Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: UserProfileStatsCard(
                  value: '134',
                  label: 'Posts',
                  valueColor: AppColors.insaneColor,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoute.userFollowersView,
                    arguments: {
                      'user': user,
                      'isOther': true,
                    },
                  ),
                  child: Obx(() {
                    final isFollowing = user.isFollowing.value;
                    return UserProfileStatsCard(
                      value: isFollowing ? '2,801' : '2,800',
                      label: 'Followers',
                      valueColor: AppColors.blueColor,
                    );
                  }),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoute.userFollowingView,
                    arguments: {
                      'user': user,
                      'isOther': true,
                    },
                  ),
                  child: UserProfileStatsCard(
                    value: '312',
                    label: 'Following',
                    valueColor: AppColors.blueColor,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: UserProfileStatsCard(
                  value: '47',
                  label: 'Events',
                  valueColor: AppColors.redColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
