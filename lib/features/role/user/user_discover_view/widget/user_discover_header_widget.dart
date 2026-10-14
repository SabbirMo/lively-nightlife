import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import '../controller/user_discover_controller.dart';

class UserDiscoverHeaderWidget extends StatelessWidget {
  final UserDiscoverController controller;

  const UserDiscoverHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          children: [
            TextProperty(
              text: 'Lively',
              textColor: AppColors.secondBlackColor,
              fontFamily: 'Sora',
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
            ),
            const Spacer(),
            // Bell Notification Icon
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoute.userNotificationView);
                  },
                  child: SvgPicture.asset(
                    IconPath.notificationBellIcon,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 16.w,
                    height: 16.h,
                    decoration: const BoxDecoration(
                      color: AppColors.redColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: TextProperty(
                      text: '4',
                      textColor: AppColors.whiteColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            // Profile image
            GestureDetector(
              onTap: () => Get.toNamed(AppRoute.userProfileView),
              child: Container(
                width: 38.w,
                height: 38.h,
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppColors.blueColor.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundImage: const NetworkImage(
                    'https://i.pravatar.cc/150?img=10',
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        // Search Bar & Filter Row
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.grey50Color,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: CustomTextfield(
                  borderRadius: 100.r,
                  borderColor: AppColors.lightGreyColor.withValues(alpha: 0.2),
                  controller: controller.searchController,
                  prefixIcon: IconPath.searchIcon,
                  fillColor: AppColors.lightGreyColor2,
                  fieldText: 'Search clubs, people...',

                  // style: TextStyle(
                  //   fontFamily: 'Poppins',
                  //   fontSize: 14.sp,
                  //   color: AppColors.blackColor,
                  // ),
                  // decoration: InputDecoration(
                  //   hintText: 'Search clubs, people...',
                  //   hintStyle: TextStyle(
                  //     fontFamily: 'Poppins',
                  //     fontSize: 14.sp,
                  //     color: AppColors.lightGreyColor,
                  //   ),
                  //   prefixIcon: Icon(
                  //     Icons.search,
                  //     color: AppColors.lightGreyColor,
                  //     size: 22.sp,
                  //   ),
                  //   border: InputBorder.none,
                  //   contentPadding: EdgeInsets.symmetric(vertical: 13.h),
                  // ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Filter Button
            Container(
              padding: EdgeInsets.all(14.sp),
              decoration: BoxDecoration(
                color: AppColors.lightGreyColor2,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lightGreyColor.withValues(alpha: 0.2),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  // Filter action triggers a search focus or toggle
                },
                child: SvgPicture.asset(
                  IconPath.filterIcon,
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blackColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
