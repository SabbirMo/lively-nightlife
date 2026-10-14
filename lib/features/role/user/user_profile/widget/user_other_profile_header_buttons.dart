import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_other_profile_controller.dart';
import 'user_profile_share_bottom_sheet.dart';

class UserOtherProfileHeaderButtons extends StatelessWidget {
  const UserOtherProfileHeaderButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserOtherProfileController>();
    final user = controller.user;

    return Row(
      children: [
        // Follow/Unfollow Button
        Obx(() {
          final isFollowing = user.isFollowing.value;
          return GestureDetector(
            onTap: () => controller.toggleFollow(),
            child: Container(
              width: 180.w,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                gradient: isFollowing
                    ? null
                    : const LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.blueColor,
                        ],
                      ),
                color: isFollowing ? const Color(0xFFFEF2F2) : null,
                borderRadius: BorderRadius.circular(100.r),
                boxShadow: isFollowing
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.blueColor.withValues(alpha: 0.3),
                          blurRadius: 10.r,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              alignment: Alignment.center,
              child: TextProperty(
                text: isFollowing ? 'Unfollow' : 'Follow',
                textColor: isFollowing ? const Color(0xFFEF4444) : AppColors.whiteColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
        SizedBox(width: 12.w),

        // Share Button
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => UserProfileShareBottomSheet(
                controller: controller,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.blueColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blueColor.withValues(alpha: 0.3),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.share_outlined,
              color: AppColors.whiteColor,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
