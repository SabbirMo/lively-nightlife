import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class UserOtherProfileHeaderNav extends StatelessWidget {
  const UserOtherProfileHeaderNav({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            // Back Arrow
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.whiteColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),

            // Title
            TextProperty(
              text: 'lively',
              textColor: AppColors.whiteColor,
              fontFamily: 'Sora',
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            const Spacer(),

            // Bell Notification
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoute.userNotificationView),
                  child: SvgPicture.asset(
                    IconPath.notificationBellIcon,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      AppColors.whiteColor,
                      BlendMode.srcIn,
                    ),
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

            // Mini Profile Avatar
            GestureDetector(
              onTap: () => Get.toNamed(AppRoute.userProfileView),
              child: CircleAvatar(
                radius: 18.r,
                backgroundImage: const NetworkImage(
                  'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
