import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextProperty(
          text: 'Lively',
          textColor: AppColors.secondBlackColor,
          fontFamily: 'Sora',
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
        ),

        const Spacer(),

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
    );
  }
}