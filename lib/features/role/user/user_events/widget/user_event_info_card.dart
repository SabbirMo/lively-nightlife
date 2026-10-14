import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';

class UserEventInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const UserEventInfoCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey50Color, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextProperty(
            text: title,
            textColor: AppColors.lightGreyColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 6.h),
          TextProperty(
            text: value,
            textColor: AppColors.secondBlackColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
