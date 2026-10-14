import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/model/user_notification_model.dart';

class UserNotificationReadView extends StatelessWidget {
  const UserNotificationReadView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserNotificationModel notification =
        Get.arguments as UserNotificationModel;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              ImagePath.bluehighlightedBackground,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: Get.back,
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(height: 30.h),
                  TextProperty(
                    text: 'Notification',
                    textColor: AppColors.blackColor,
                    fontFamily: 'Sora',
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 42.r,
                          backgroundImage: const AssetImage(
                            ImagePath.feedImage,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        TextProperty(
                          text: notification.userName.isEmpty
                              ? 'Lively'
                              : notification.userName,
                          textColor: AppColors.blackColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 10.h),
                        TextProperty(
                          text: notification.message,
                          textAlign: TextAlign.center,
                          textColor: AppColors.greyColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 12.h),
                        TextProperty(
                          text: notification.time,
                          textColor: AppColors.greyColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        if (notification.postImage != null) ...[
                          SizedBox(height: 24.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),

                            child: Image.asset(
                              notification.postImage!,
                              width: double.infinity,
                              height: 220.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    borderRadius: BorderRadius.circular(100.r),
                    text: _buttonText(notification),
                    onTap: () {
                      Get.snackbar(
                        'Coming Soon',
                        'Navigation will be connected after API integration.',
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buttonText(UserNotificationModel notification) {
    switch (notification.type) {
      case UserNotificationType.like:
      case UserNotificationType.comment:
        return 'View Post';

      case UserNotificationType.follow:
        return 'View Profile';

      case UserNotificationType.event:
        return 'View Event';

      case UserNotificationType.ticket:
        return 'View Ticket';

      case UserNotificationType.checkIn:
        return 'View Check-In';

      case UserNotificationType.nearby:
        return 'Explore Events';
    }
  }
}
