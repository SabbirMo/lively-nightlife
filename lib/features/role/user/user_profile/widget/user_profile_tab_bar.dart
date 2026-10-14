import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_profile_controller.dart';

class UserProfileTabBar extends StatelessWidget {
  const UserProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserProfileController>();

    return Container(
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
                index: 0,
                icon: Icons.grid_view_rounded,
                isActive: activeTab == 0,
                onTap: () => controller.changeTab(0),
              ),
            ),
            Expanded(
              child: _buildTabItem(
                index: 1,
                icon: Icons.bookmark_border_rounded,
                isActive: activeTab == 1,
                onTap: () => controller.changeTab(1),
              ),
            ),
            Expanded(
              child: _buildTabItem(
                index: 2,
                icon: Icons.star_border_rounded,
                isActive: activeTab == 2,
                onTap: () => controller.changeTab(2),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppColors.gradientStartColor, AppColors.gradientMiddleColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
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
