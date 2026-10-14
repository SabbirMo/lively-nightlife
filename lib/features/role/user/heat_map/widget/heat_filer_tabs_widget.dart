import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/controller/heat_map_controller.dart';

class HeatFilterTabsWidget extends StatelessWidget {
  const HeatFilterTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HeatMapController>();

    return Obx(
      () => Row(
        children: [
          _tab('Live Now', 0, controller),

          SizedBox(width: 10.w),

          _tab('Tonight', 1, controller),

          SizedBox(width: 10.w),

          _tab('This Week', 2, controller),
        ],
      ),
    );
  }

  Widget _tab(String text, int index, HeatMapController controller) {
    final selected = controller.selectedTab.value == index;

    return GestureDetector(
      onTap: () {
        controller.changeTab(index);
      },

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),

        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.white,

          borderRadius: BorderRadius.circular(100.r),
        ),

        child: TextProperty(
          text: text,
          textColor: selected ? Colors.white : AppColors.blackColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
