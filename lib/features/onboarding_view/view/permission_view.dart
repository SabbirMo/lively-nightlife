import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/controller/permissions_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/model/permission_type.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class PermissionView extends GetView<PermissionsController> {
  final PermissionType type;

  const PermissionView({super.key, required this.type});

  bool get isLocation => type == PermissionType.location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Image.asset(
            ImagePath.bluehighlightedBackground,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        isLocation
                            ? IconPath.planeIcon
                            : IconPath.notificationIcon,
                        width: 30.w,
                        height: 30.h,
                      )
                      
                      // Icon(
                      //   isLocation
                      //       ? Icons.near_me_outlined
                      //       : Icons.notifications_none,
                      //   size: 36.sp,
                      //   color: Colors.black,
                      // ),
                    ),
                
                    SizedBox(height: 20.h),
                
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextProperty(
                        text: isLocation ? 'Enable Location' : 'Stay in the Loop',
                        textColor: AppColors.blackColor,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                
                    SizedBox(height: 12.h),
                
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextProperty(
                        text: isLocation
                            ? 'Get the most out of NIGHTLIFE by sharing your location to find clubs and events near you in real-time.'
                            : 'Get real-time alerts for nearby events, Heat Map activity, and when your favorite clubs drop new content.',
                        textColor: AppColors.greyColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        lineHeight: 1.5,
                      ),
                    ),
                
                    SizedBox(height: 32.h),
                
                    CustomButton(
                      text: isLocation
                          ? 'Enable Location Access'
                          : 'Enable Notifications',
                      borderRadius: BorderRadius.circular(100.r),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      onTap: () async {
                        if (isLocation) {
                          await controller.requestLocationPermission();
                
                          Get.to(
                            () => const PermissionView(
                              type: PermissionType.notification,
                            ),
                          );
                        } else {
                          await controller.requestNotificationPermission();
                
                          Get.offAllNamed(AppRoute.getStartedView);
                        }
                      },
                    ),
                
                    SizedBox(height: 18.h),
                
                    GestureDetector(
                      onTap: () {
                        if (isLocation) {
                          Get.to(
                            () => const PermissionView(
                              type: PermissionType.notification,
                            ),
                          );
                        } else {
                          Get.offNamed(AppRoute.vibeSelectionView);
                        }
                      },
                      child: Center(
                        child: TextProperty(
                          text: 'Not now',
                          textColor: AppColors.greyColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
