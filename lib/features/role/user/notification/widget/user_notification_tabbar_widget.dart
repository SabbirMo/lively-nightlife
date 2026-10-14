import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/notification/controller/user_notification_controller.dart';

class UserNotificationTabbarWidget extends GetView<UserNotificationController> {
  const UserNotificationTabbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = ['All', 'Unread', 'Read', 'Likes', 'Social', 'Events'];

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (_, index) {
          return Obx(() {
            final isSelected = controller.selectedTab.value == index;

            return GestureDetector(
              onTap: () {
                controller.changeTab(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.blueColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: TextProperty(
                  text: tabs[index],
                  textColor: isSelected
                      ? AppColors.whiteColor
                      : AppColors.greyColor,
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
