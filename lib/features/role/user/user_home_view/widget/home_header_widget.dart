import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/controller/user_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class HomeHeaderWidget extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const HomeHeaderWidget({
    super.key,
    this.showBackButton = false,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<UserHomeController>()
        ? Get.find<UserHomeController>()
        : Get.put(UserHomeController());

    return Row(
      children: [
        if (showBackButton) ...[
          GestureDetector(
            onTap: onBackTap ?? () => Get.back(),
            child: SvgPicture.asset(
              IconPath.backButton,
              width: 16.w,
              height: 16.h,
              colorFilter: const ColorFilter.mode(
                AppColors.secondBlackColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],

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
          onTap: () async {
            await Get.toNamed(AppRoute.userProfileView);
            controller.fetchUserProfile();
          },
          child: Container(
            width: 38.w,
            height: 38.h,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppColors.blueColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Obx(() {
                final imgUrl = controller.profileImageUrl;
                const defaultImage = 'https://i.pravatar.cc/150?img=10';
                final initial = controller.name.isNotEmpty
                    ? controller.name[0].toUpperCase()
                    : 'U';

                if (imgUrl.isNotEmpty) {
                  return Image.network(
                    imgUrl,
                    width: 34.w,
                    height: 34.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network(
                      defaultImage,
                      width: 34.w,
                      height: 34.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 34.w,
                        height: 34.h,
                        color: AppColors.blueColor,
                        alignment: Alignment.center,
                        child: Text(
                          initial,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Image.network(
                  defaultImage,
                  width: 34.w,
                  height: 34.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 34.w,
                    height: 34.h,
                    color: AppColors.blueColor,
                    alignment: Alignment.center,
                    child: Text(
                      initial,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}