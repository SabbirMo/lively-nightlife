import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/controllers/club_bottom_navbar_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_chat/view/club_chat_inbox_view.dart';

class CustomClubBottomNavbar extends StatelessWidget {
  const CustomClubBottomNavbar({super.key});

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

          // _item(
          //   index: 1,
          //   label: 'Events',
          //   icon: IconPath.eventIcon,
          // ),
          _item(index: 2, label: 'Messages', icon: IconPath.messageIcon),
        ],
      ),
    );
  }

  Widget _item({
    required int index,
    required String label,
    required String icon,
  }) {
    final controller = Get.find<ClubBottomNavbarController>();

    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedIndex.value == index;

        return GestureDetector(
          onTap: () {
            if (index == 2) {
              Get.to(() => const ClubChatInboxView());
            } else {
              controller.changeTab(index);
            }
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
}
