import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class UserProfileHeaderWidget extends StatelessWidget {
  const UserProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 272.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 240.h,
            child: Image.network(
              'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 240.h,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.whiteColor, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        IconPath.backButton,
                        colorFilter: const ColorFilter.mode(
                          AppColors.whiteColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      TextProperty(
                        text: 'lively',
                        textColor: AppColors.whiteColor,
                        fontFamily: 'Sora',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
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
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16.w,
            right: 16.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: const BoxDecoration(
                        color: AppColors.mildColor,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 36.r,
                        backgroundImage: const NetworkImage(
                          'https://i.pravatar.cc/150?img=10',
                        ),
                      ),
                    ),
                    Positioned(
                      right: 2.w,
                      top: 2.h,
                      child: Container(
                        width: 14.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: AppColors.mildColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.whiteColor,
                            width: 2.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                CustomButton(
                  text: 'Edit',
                  color: AppColors.lightGreyColor.withValues(alpha: 0.15),
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(100.r),
                  textColor: AppColors.blueColor,
                  icon: Icons.edit,
                  iconColor: AppColors.blueColor,
                  buttonWidth: 90.w,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  onTap: () {
                    Get.snackbar('Edit Profile', 'Edit profile coming soon!');
                  },
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoute.userSettingsView),
                  child: Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.settings,
                      color: AppColors.blueColor,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
