import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/widget/home_header_widget.dart';
import '../controller/user_discover_controller.dart';

class UserDiscoverHeaderWidget extends StatelessWidget {
  final UserDiscoverController controller;

  const UserDiscoverHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeHeaderWidget(),
        SizedBox(height: 20.h),
        // Search Bar & Filter Row
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.grey50Color,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: CustomTextfield(
                  borderRadius: 100.r,
                  borderColor: AppColors.lightGreyColor.withValues(alpha: 0.2),
                  controller: controller.searchController,
                  prefixIcon: IconPath.searchIcon,
                  fillColor: AppColors.lightGreyColor2,
                  fieldText: 'Search clubs, people...',
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Filter Button
            Container(
              padding: EdgeInsets.all(14.sp),
              decoration: BoxDecoration(
                color: AppColors.lightGreyColor2,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lightGreyColor.withValues(alpha: 0.2),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  // Filter action triggers a search focus or toggle
                },
                child: SvgPicture.asset(
                  IconPath.filterIcon,
                  width: 20.w,
                  height: 20.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.blackColor,
                    BlendMode.srcIn,
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
