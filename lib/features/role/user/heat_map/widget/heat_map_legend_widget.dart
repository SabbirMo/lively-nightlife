import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';

class HeatMapLegendWidget extends StatelessWidget {
  const HeatMapLegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),

      decoration: BoxDecoration(
        color: AppColors.whiteColor,

        borderRadius: BorderRadius.circular(18.r),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          _item(AppColors.insaneColor, 'Insane'),

          SizedBox(height: 14.h),

          _item(AppColors.hotColor, 'Hot'),

          SizedBox(height: 14.h),

          _item(AppColors.activeColor, 'Active'),

          SizedBox(height: 14.h),

          _item(AppColors.mildColor, 'Mild'),
        ],
      ),
    );
  }

  Widget _item(Color color, String title) {
    return Row(
      children: [
        Container(
          width: 14.w,
          height: 14.h,

          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        SizedBox(width: 10.w),

        TextProperty(
          text: title,
          textColor: AppColors.blackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
