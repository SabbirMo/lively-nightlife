import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_chat_controller.dart';

class UserChatFilterTabBar extends StatelessWidget {
  const UserChatFilterTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserChatController>();
    final List<String> tabTitles = ['For You', 'Following', 'Nearby', 'Trending'];

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: List.generate(
            tabTitles.length,
            (index) => Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: () => controller.selectTab(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: controller.selectedTab.value == index
                        ? AppColors.blueColor
                        : AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: controller.selectedTab.value == index
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ],
                    border: Border.all(
                      color: controller.selectedTab.value == index
                          ? AppColors.blueColor
                          : AppColors.lightGreyColor.withValues(alpha: 0.15),
                    ),
                  ),
                  child: TextProperty(
                    text: tabTitles[index],
                    textColor: controller.selectedTab.value == index
                        ? AppColors.whiteColor
                        : AppColors.secondBlackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
