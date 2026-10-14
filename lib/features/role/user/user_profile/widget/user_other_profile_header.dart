import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import '../controller/user_other_profile_controller.dart';
import 'user_other_profile_header_nav.dart';
import 'user_other_profile_header_buttons.dart';

class UserOtherProfileHeader extends StatelessWidget {
  const UserOtherProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserOtherProfileController>();
    final user = controller.user;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Faded Cover Photo
        Container(
          height: 240.h,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImagePath.feedImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.transparent,
                  AppColors.whiteColor,
                ],
                stops: const [0.0, 0.65, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Floating Header Row (Nav)
        const UserOtherProfileHeaderNav(),

        // Overlapping Main Profile Avatar
        Positioned(
          left: 16.w,
          bottom: -40.h,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 46.r,
                  backgroundImage: NetworkImage(user.avatar),
                ),
              ),
              Positioned(
                right: 8.w,
                top: 4.h,
                child: Container(
                  width: 16.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.whiteColor,
                      width: 2.r,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Follow/Unfollow & Share Buttons Row
        Positioned(
          right: 16.w,
          bottom: -24.h,
          child: const UserOtherProfileHeaderButtons(),
        ),
      ],
    );
  }
}
