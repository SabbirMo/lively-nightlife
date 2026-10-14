import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
        (index) {
          final isActive = index == currentStep - 1;
          return Padding(
            padding: EdgeInsets.only(right: index < totalSteps - 1 ? 6.w : 0),
            child: Container(
              width: 32.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryColor
                    : AppColors.blackColor,
                borderRadius: BorderRadius.circular(1.5.r),
              ),
            ),
          );
        },
      ),
    );
  }
}
