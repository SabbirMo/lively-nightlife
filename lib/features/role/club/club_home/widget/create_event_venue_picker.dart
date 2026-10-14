import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_create_event_controller.dart';

class CreateEventVenuePicker extends GetView<ClubCreateEventController> {
  const CreateEventVenuePicker({super.key});

  Widget _buildVenueOption(String venue, String avatar) {
    return Obx(() {
      final isSelected = controller.selectedVenue.value == venue;
      return GestureDetector(
        onTap: () => controller.selectVenue(venue),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor.withValues(alpha: 0.08) : AppColors.lightGreyColor2,
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 1.2.w,
            ),
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 12.r,
                backgroundImage: NetworkImage(avatar),
              ),
              SizedBox(width: 8.w),
              TextProperty(
                text: venue,
                textColor: isSelected ? AppColors.primaryColor : AppColors.greyColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextProperty(
          text: 'Venue / Club',
          textColor: AppColors.blackColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 10.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildVenueOption('Omnia Nightclub', 'https://i.pravatar.cc/150?img=10'),
              SizedBox(width: 12.w),
              _buildVenueOption('Marquee Nightclub', 'https://i.pravatar.cc/150?img=11'),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        CustomTextfield(
          controller: controller.customVenueController,
          fieldText: 'Or type a custom venue address...',
          hintTextColor: AppColors.lightGreyColor,
          fillColor: AppColors.lightGreyColor2,
          borderRadius: 16.r,
          onChanged: controller.onCustomVenueChanged,
        ),
      ],
    );
  }
}
