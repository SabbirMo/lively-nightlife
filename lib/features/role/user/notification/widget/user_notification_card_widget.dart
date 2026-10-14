import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/controller/user_notification_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/model/user_notification_model.dart';
import 'user_notification_avatar_widget.dart';

class UserNotificationCardWidget extends GetView<UserNotificationController> {
  final UserNotificationModel notification;

  const UserNotificationCardWidget({super.key, required this.notification});

  bool get showPostImage {
    return notification.type == UserNotificationType.like ||
        notification.type == UserNotificationType.comment;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.openNotification(notification);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: notification.isRead.value
                ? Colors.transparent
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// AVATAR
              notification.type == UserNotificationType.ticket ||
                      notification.type == UserNotificationType.nearby
                  ? _systemNotificationIcon(notification.type)
                  : UserNotificationAvatarWidget(type: notification.type),
              SizedBox(width: 12.w),

              /// CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: notification.userName,
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: ' ${notification.message}',
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),
                    TextProperty(
                      text: notification.time,
                      textColor: AppColors.greyColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              /// POST IMAGE
              if (showPostImage)
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    image: DecorationImage(
                      image: AssetImage(notification.postImage ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              /// UNREAD DOT
              if (!notification.isRead.value)
                Padding(
                  padding: EdgeInsets.only(left: 10.w, top: 8.h),
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _systemNotificationIcon(UserNotificationType type) {
  String icon;

  switch (type) {
    case UserNotificationType.ticket:
      icon = IconPath.notifyTicketConfirmIcon;
      break;

    case UserNotificationType.nearby:
      icon = IconPath.notifyEventIcon;
      break;

    default:
      icon = IconPath.notifyEventIcon;
  }

  return Container(
    width: 58.w,
    height: 58.w,

    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(18.r),
    ),

    child: Center(
      child: SvgPicture.asset(icon, width: 26.w, height: 26.h),
    ),
  );
}
