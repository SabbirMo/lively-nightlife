import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/controllers/user_bottom_navigation_bar_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/view/heat_map_view.dart';

class CustomUserBottomNavbar extends StatelessWidget {
  const CustomUserBottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,

        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),

      child: Row(
        children: [
          _item(index: 0, label: 'Home', icon: IconPath.homeIcon),

          _item(index: 1, label: 'Discover', icon: IconPath.discoverIcon),

          _centerButton(),

          _item(index: 3, label: 'Events', icon: IconPath.eventIcon),

          _item(index: 4, label: 'Messages', icon: IconPath.messageIcon),
        ],
      ),
    );
  }

  Widget _item({
    required int index,
    required String label,
    required String icon,
  }) {
    final controller = Get.find<UserBottomNavbarController>();

    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedIndex.value == index;

        return GestureDetector(
          onTap: () {
            controller.changeTab(index);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.blueColor : AppColors.greyColor,
                  BlendMode.srcIn,
                ),
              ),

              SizedBox(height: 6.h),

              TextProperty(
                text: label,
                textColor: isSelected
                    ? AppColors.blueColor
                    : AppColors.greyColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _centerButton() {
    final controller = Get.find<UserBottomNavbarController>();

    return Obx(() {
      final isSelected = controller.selectedIndex.value == 2;

      return GestureDetector(
        onTap: () {
          // controller.changeTab(2);
          Get.to(() => const HeatMapView());
        },
        child: Container(
          width: 50.w,
          alignment: Alignment.topCenter,
          child: Transform.translate(
            offset: Offset(0, -18.h),
            child: Container(
              width: 62.w,
              height: 62.w,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blueColor : AppColors.blueColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  IconPath.locationIcon,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.whiteColor : AppColors.whiteColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
