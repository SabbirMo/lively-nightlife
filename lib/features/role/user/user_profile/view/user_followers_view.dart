import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import '../controller/user_profile_controller.dart';
import '../model/follow_user_model.dart';

class UserFollowersView extends StatelessWidget {
  const UserFollowersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserProfileController>();
    final args = Get.arguments;
    final bool isOther = args != null && args is Map && args['isOther'] == true;
    final FollowUserModel? otherUser = isOther ? args['user'] as FollowUserModel : null;
    final String titleText = isOther ? '${otherUser!.name}\'s Followers' : 'Followers';

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          // Top Soft Blue Gradient Background
          Container(
            height: 160.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFDBEAFE),
                  Color(0xFFEFF6FF),
                  AppColors.whiteColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom Header Row
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.blackColor,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Title
                      TextProperty(
                        text: titleText,
                        textColor: AppColors.blackColor,
                        fontFamily: 'Sora',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      const Spacer(),

                      // Notification Bell with Badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoute.userNotificationView),
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

                      // Profile Avatar
                      CircleAvatar(
                        radius: 18.r,
                        backgroundImage: const NetworkImage(
                          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6',
                        ),
                      ),
                    ],
                  ),
                ),

                // Followers List
                Expanded(
                  child: Obx(() {
                    final list = isOther
                        ? controller.allUsers.where((u) => u.username != otherUser!.username).toList()
                        : controller.followersList;
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      itemCount: list.length,
                      separatorBuilder: (context, index) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final FollowUserModel user = list[index];

                        return Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.toNamed(
                                  AppRoute.userOtherProfileView,
                                  arguments: user,
                                ),
                                child: Row(
                                  children: [
                                    // Circular Avatar
                                    CircleAvatar(
                                      radius: 26.r,
                                      backgroundImage: NetworkImage(user.avatar),
                                      backgroundColor: AppColors.grey50Color,
                                    ),
                                    SizedBox(width: 14.w),

                                    // Name details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextProperty(
                                            text: user.name,
                                            textColor: AppColors.blackColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          SizedBox(height: 2.h),
                                          TextProperty(
                                            text: user.username,
                                            textColor: AppColors.lightGreyColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Follow/Unfollow pill button
                            Obx(() {
                              final isFollowing = user.isFollowing.value;
                              return GestureDetector(
                                onTap: () => controller.toggleFollow(user),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isFollowing
                                        ? const Color(0xFFFEF2F2)
                                        : const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: TextProperty(
                                    text: isFollowing ? 'Unfollow' : 'follow',
                                    textColor: isFollowing
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFF2B7FFF),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
