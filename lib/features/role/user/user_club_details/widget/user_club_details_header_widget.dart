import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_club_details/controller/user_club_details_controller.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import 'user_club_share_bottom_sheet.dart';

class UserClubDetailsHeaderWidget extends StatelessWidget {
  final UserClubDetailsController controller;

  const UserClubDetailsHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290.h,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover Photo Container (Top 250.h of the parent)
          Container(
            height: 270.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImagePath.clubCoverPhoto),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.blackColor.withValues(alpha: 0.5),
                    Colors.transparent,
                    AppColors.whiteColor, // White fade at the bottom
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Navigation Bar Row (Overlaid on top of cover photo)
          Positioned(
            top: 40.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: SvgPicture.asset(
                    IconPath.backButton,
                    // width: 16.w,
                    height: 16.h,
                    colorFilter: const ColorFilter.mode(
                      AppColors.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                TextProperty(
                  text: 'Lively',
                  textColor: AppColors.whiteColor,
                  fontFamily: 'Sora',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
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
                // Profile
                Container(
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
              ],
            ),
          ),

          // Overlapping bottom elements (Club logo, Follow/Unfollow, Share button)
          // Positioned at the very bottom of the 290.h parent container
          Positioned(
            bottom: 0,
            left: 20.w,
            right: 20.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Club avatar overlapping border
                Stack(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.whiteColor,
                          width: 4.w,
                        ),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://i.pravatar.cc/150?img=60',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Green online dot
                    Positioned(
                      right: 4.w,
                      top: 4.h,
                      child: Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: AppColors.mildColor, // Green
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
                // Follow/Unfollow Button
                Obx(() {
                  final following = controller.isFollowing.value;
                  return CustomButton(
                    borderRadius: BorderRadius.circular(100.r),
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 8.h,
                    ),
                    color: following
                        ? AppColors.redColor.withValues(alpha: 0.08)
                        : AppColors.blueColor,
                    text: following ? 'Unfollow' : 'Follow',
                    textColor: following
                        ? AppColors.redColor
                        : AppColors.whiteColor,
                    onTap: controller.toggleFollow,
                  );

                  // GestureDetector(
                  //   onTap: controller.toggleFollow,
                  //   child: Container(
                  //     width: 130.w,
                  //     height: 44.h,
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       color: following
                  //           ? AppColors.grey50Color.withValues(alpha: 0.4)
                  //           : AppColors.blueColor,
                  //       borderRadius: BorderRadius.circular(22.r),
                  //       border: following
                  //           ? Border.all(
                  //               color: AppColors.lightGreyColor.withValues(
                  //                 alpha: 0.3,
                  //               ),
                  //               width: 1.w,
                  //             )
                  //           : null,
                  //     ),
                  //     child: TextProperty(
                  //       text: following ? 'Unfollow' : 'Follow',
                  //       textColor: following
                  //           ? AppColors.redColor
                  //           : AppColors.whiteColor,
                  //       fontSize: 14.sp,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  // );
                }),
                SizedBox(width: 10.w),
                // Share Button
                GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      UserClubShareBottomSheet(controller: controller),
                    );
                  },
                  child: Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: const BoxDecoration(
                      color: AppColors.blueColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      IconPath.shareIcon,
                      width: 20.w,
                      height: 20.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.whiteColor,
                        BlendMode.srcIn,
                      ),
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
