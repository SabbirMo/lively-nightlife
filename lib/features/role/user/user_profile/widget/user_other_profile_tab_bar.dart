import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_other_profile_controller.dart';

class UserOtherProfileTabBar extends StatelessWidget {
  const UserOtherProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserOtherProfileController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: AppColors.lightGreyColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Obx(() {
          final activeTab = controller.selectedTab.value;
          return Row(
            children: [
              Expanded(
                child: _buildTabItem(
                  icon: Icons.grid_on_rounded,
                  isActive: activeTab == 0,
                  onTap: () => controller.changeTab(0),
                ),
              ),
              Expanded(
                child: _buildTabItem(
                  icon: Icons.star_border_rounded,
                  isActive: activeTab == 1,
                  onTap: () => controller.changeTab(1),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          gradient: isActive
              ? const LinearGradient(
                  colors: [
                    AppColors.gradientStartColor,
                    AppColors.gradientMiddleColor,
                    AppColors.gradientEndColor,
                  ],
                )
              : null,
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.whiteColor : AppColors.lightGreyColor,
          size: 20.sp,
        ),
      ),
    );
  }
}
