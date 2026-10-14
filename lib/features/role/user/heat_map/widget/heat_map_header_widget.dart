import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/controller/heat_map_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/widget/heat_map_filter_bottom_sheet.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class HeatMapHeaderWidget extends StatelessWidget {
  const HeatMapHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
      final controller = Get.find<HeatMapController>();
    return Column(
      children: [
        /// TOP BAR
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(IconPath.backButton, height: 16.h),
            ),

            SizedBox(width: 12.w),

            TextProperty(
              text: 'lively',
              textColor: AppColors.blackColor,
              fontSize: 24.sp,
              fontFamily: 'Sora',
              fontWeight: FontWeight.w700,
            ),

            const Spacer(),

            GestureDetector(
              onTap: () => Get.toNamed(AppRoute.userProfileView),
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.15),
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/150?img=12',
                    fit: BoxFit.cover,
                    width: 40.w,
                    height: 40.h,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),

        /// SEARCH + FILTER
        Row(
          children: [
            Expanded(
              child: CustomTextfield(
                controller: controller.searchController,

                fieldText: 'Search clubs, people...',
                fillColor: AppColors.greyColor.withValues(alpha: .05),
                borderRadius: 100.r,
                onChanged: controller.updateSearch,
              ),
            ),

            SizedBox(width: 12.w),

            GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  const HeatMapFilterBottomSheet(),
                  isScrollControlled: true,
                );
              },
              child: Container(
                width: 52.w,
                height: 52.h,

                decoration: BoxDecoration(
                  color: AppColors.greyColor.withValues(alpha: .05),
                  shape: BoxShape.circle,

                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(.05),
                  //     blurRadius: 12,
                  //   ),
                  // ],
                ),

                child: Center(
                  child: SvgPicture.asset(
                    IconPath.filterIcon,
                    width: 22.w,
                    height: 22.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
