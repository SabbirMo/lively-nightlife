import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/controller/user_home_controller.dart';

class HomeTabWidget extends StatelessWidget {
  const HomeTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserHomeController>();

    return Obx(
      () => Row(
        children: [
          _tab(title: 'For You', index: 0, controller: controller),

          SizedBox(width: 10.w),

          _tab(title: 'Following', index: 1, controller: controller),

          SizedBox(width: 10.w),

          _tab(title: 'Nearby', index: 2, controller: controller),
        ],
      ),
    );
  }

  Widget _tab({
    required String title,
    required int index,
    required UserHomeController controller,
  }) {
    final isSelected = controller.selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.changeTab(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blueColor : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(
              width: 2.w,
              color: isSelected ? AppColors.blueColor : AppColors.grey50Color,
            ),
          ),
          child: TextProperty(
            text: title,
            textColor: isSelected ? AppColors.whiteColor : AppColors.blackColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
