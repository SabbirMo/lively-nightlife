import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';

class UserNotificationEmptyWidget extends StatelessWidget {
  const UserNotificationEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 80.h),
        child: Column(
          children: [
            Icon(
              Icons.notifications_none,
              size: 60.sp,
              color: AppColors.greyColor,
            ),
            SizedBox(height: 16.h),
            TextProperty(
              text: 'No notifications found',
              textColor: AppColors.greyColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
