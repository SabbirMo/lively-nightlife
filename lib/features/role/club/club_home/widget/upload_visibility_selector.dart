import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_upload_content_controller.dart';

class UploadVisibilitySelector extends GetView<ClubUploadContentController> {
  const UploadVisibilitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextProperty(
          text: 'Who can see this?',
          textColor: AppColors.lightGreyColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 12.h),
        _buildVisibilityOption(
          'Public',
          IconPath.globalIcon,
          'Public',
          'Anyone can see this',
        ),
        _buildVisibilityOption(
          'Followers',
          IconPath.purplePerson,
          'Followers',
          'Only your followers',
        ),
        _buildVisibilityOption('Only Me', IconPath.lock, 'Only Me', 'Just you'),
      ],
    );
  }

  Widget _buildVisibilityOption(
    String value,
    String icon,
    String title,
    String subtitle,
  ) {
    return Obx(() {
      final isSelected = controller.visibility.value == value;
      return GestureDetector(
        onTap: () => controller.visibility.value = value,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.greenColor.withValues(alpha: 0.15)
                : AppColors.lightGreyColor2,
            border: Border.all(
              color: isSelected ? AppColors.greenColor : Colors.transparent,
              width: 1.2.w,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.greenColor.withValues(alpha: 0.1)
                      : AppColors.grey50Color,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? AppColors.greenColor
                        : AppColors.lightGreyColor,
                    BlendMode.srcIn,
                  ),
                  // size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextProperty(
                      text: title,
                      textColor: AppColors.blackColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 2.h),
                    TextProperty(
                      text: subtitle,
                      textColor: AppColors.lightGreyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                SvgPicture.asset(
                  IconPath.tickIcon,
                  // colorFilter: ColorFilter.mode(
                  //   isSelected
                  //       ? AppColors.greenColor
                  //       : AppColors.lightGreyColor,
                  //   BlendMode.srcIn,
                  // ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
