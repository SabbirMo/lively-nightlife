import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_discover_controller.dart';

class UserDiscoverTabBarWidget extends StatelessWidget {
  final UserDiscoverController controller;

  const UserDiscoverTabBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final List<String> tabTitles = ['All', 'Clubs', 'Events', 'People'];

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            tabTitles.length,
            (index) => Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: _buildTabChip(title: tabTitles[index], index: index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabChip({required String title, required int index}) {
    final isSelected = controller.selectedTab.value == index;

    return GestureDetector(
      onTap: () {
        controller.changeTab(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blueColor : AppColors.grey100Color,
          borderRadius: BorderRadius.circular(20.r),

          border: Border.all(
            color: isSelected
                ? AppColors.blueColor
                : AppColors.lightGreyColor.withValues(alpha: 0.15),
          ),
        ),
        child: TextProperty(
          text: title,
          textColor: isSelected
              ? AppColors.whiteColor
              : AppColors.secondBlackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
