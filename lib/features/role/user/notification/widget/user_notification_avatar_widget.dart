import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/model/user_notification_model.dart';

class UserNotificationAvatarWidget extends StatelessWidget {
  final UserNotificationType type;

  const UserNotificationAvatarWidget({super.key, required this.type});

  String get actionIcon {
    switch (type) {
      case UserNotificationType.like:
        return IconPath.notifyLikeIcon;

      case UserNotificationType.comment:
        return IconPath.notifyCommentIcon;

      case UserNotificationType.follow:
        return IconPath.notifyFollowIcon;

      case UserNotificationType.event:
        return IconPath.notifyCalendarIcon;

      case UserNotificationType.ticket:
        return IconPath.notifyTicketConfirmIcon;

      case UserNotificationType.checkIn:
        return IconPath.notifyCheckIcon;

      case UserNotificationType.nearby:
        return IconPath.notifyEventIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,

      children: [
        CircleAvatar(
          radius: 24.r,

          backgroundImage: const AssetImage('assets/images/feedImage.png'),
        ),

        Positioned(
          bottom: -2,
          right: -2,

          child: Container(
            width: 20.w,
            height: 20.w,

            padding: EdgeInsets.all(4.w),

            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,

              border: Border.all(color: AppColors.whiteColor),
            ),

            child: SvgPicture.asset(actionIcon),
          ),
        ),
      ],
    );
  }
}
