import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/model/club_activity_model.dart';

class ClubRecentActivity extends StatelessWidget {
  const ClubRecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClubHomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextProperty(
          text: 'Recent Activity',
          textColor: AppColors.blackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 16.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.recentActivities.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final activity = controller.recentActivities[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 32.h,
                  width: 32.w,
                  decoration: BoxDecoration(
                    color: _getBgColor(activity.type),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _getIcon(activity.type),
                    size: 18.sp,
                    color: _getColor(activity.type),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextProperty(
                    text: activity.message,
                    textColor: AppColors.greyColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    lineHeight: 1.3,
                  ),
                ),
                SizedBox(width: 8.w),
                TextProperty(
                  text: activity.time,
                  textColor: AppColors.lightGreyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Color _getBgColor(ActivityType type) {
    switch (type) {
      case ActivityType.follower:
        return AppColors.greenColor.withValues(alpha: .2);
      case ActivityType.ticket:
        return AppColors.purpleColor.withValues(alpha: .2);
      case ActivityType.review:
      case ActivityType.warning:
        return AppColors.amberColor.withValues(alpha: .2);
    }
  }

  Color _getColor(ActivityType type) {
    switch (type) {
      case ActivityType.follower:
        return const Color(0xFF00C853);
      case ActivityType.ticket:
        return AppColors.purpleColor;
      case ActivityType.review:
        return AppColors.amberColor;
      case ActivityType.warning:
        return AppColors.amberColor;
    }
  }

  IconData _getIcon(ActivityType type) {
    switch (type) {
      case ActivityType.follower:
        return Icons.check_circle_outline_rounded;
      case ActivityType.ticket:
        return Icons.confirmation_number_outlined;
      case ActivityType.review:
        return Icons.star_outline_rounded;
      case ActivityType.warning:
        return Icons.error_outline_rounded;
    }
  }
}
