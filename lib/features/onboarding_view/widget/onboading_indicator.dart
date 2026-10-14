import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';


class OnboardingIndicator extends StatelessWidget {
  final bool isActive;

  const OnboardingIndicator({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: isActive ? 38.w : 18.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primaryColor
            : AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(100.r),
      ),
    );
  }
}