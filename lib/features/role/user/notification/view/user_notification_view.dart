import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/controller/user_notification_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/widget/user_notification_card_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/widget/user_notification_empty_widget.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/widget/user_notification_tabbar_widget.dart';

class UserNotificationView extends GetView<UserNotificationController> {
  const UserNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.defaultBackgroundColor,

      body: Stack(
        children: [
          /// BACKGROUND
          Positioned.fill(
            child: Image.asset(
              ImagePath.bluehighlightedBackground,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextProperty(
                        text: 'Notifications',
                        textColor: AppColors.secondBlackColor,
                        fontFamily: 'Sora',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.markAllAsRead();
                        },
                        child: TextProperty(
                          text: 'Mark all read',
                          textColor: AppColors.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  /// TAB BAR
                  const UserNotificationTabbarWidget(),
                  SizedBox(height: 20.h),

                  /// LIST
                  Expanded(
                    child: Obx(() {
                      final notifications = controller.filteredNotifications;
                      if (notifications.isEmpty) {
                        return const UserNotificationEmptyWidget();
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 30.h),
                        itemCount: notifications.length,
                        itemBuilder: (_, index) {
                          return UserNotificationCardWidget(
                            notification: notifications[index],
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
