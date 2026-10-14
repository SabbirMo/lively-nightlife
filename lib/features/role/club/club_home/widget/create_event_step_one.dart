import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_create_event_controller.dart';
import 'create_event_banner_picker.dart';
import 'create_event_venue_picker.dart';
import 'event_date_picker_bottomsheet.dart';

class CreateEventStepOne extends GetView<ClubCreateEventController> {
  const CreateEventStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CreateEventBannerPicker(),
          SizedBox(height: 20.h),
          TextProperty(
            text: 'Event Title *',
            textColor: AppColors.blackColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 6.h),
          CustomTextfield(
            controller: controller.titleController,
            fieldText: 'E.g. NEON CARNIVAL: Exchange LA Rave Night',
            hintTextColor: AppColors.lightGreyColor,
            fillColor: AppColors.lightGreyColor2,
            borderRadius: 16.r,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextProperty(
                      text: 'Date *',
                      textColor: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          const EventDatePickerBottomSheet(),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: AbsorbPointer(
                        child: CustomTextfield(
                          controller: controller.dateController,
                          fieldText: 'MM/DD/YYYY',
                          fillColor: AppColors.lightGreyColor2,
                          borderRadius: 16.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextProperty(
                      text: 'Start Time *',
                      textColor: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: () => controller.selectTime(
                        context,
                        controller.startTimeController,
                      ),
                      child: AbsorbPointer(
                        child: CustomTextfield(
                          controller: controller.startTimeController,
                          fieldText: '00:00 AM/PM',
                          fillColor: AppColors.lightGreyColor2,
                          borderRadius: 16.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextProperty(
                      text: 'End Time',
                      textColor: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: () => controller.selectTime(
                        context,
                        controller.endTimeController,
                      ),
                      child: AbsorbPointer(
                        child: CustomTextfield(
                          controller: controller.endTimeController,
                          fieldText: '00:00 AM/PM',
                          fillColor: AppColors.lightGreyColor2,
                          borderRadius: 16.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextProperty(
                      text: 'Capacity',
                      textColor: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 6.h),
                    CustomTextfield(
                      controller: controller.capacityController,
                      fieldText: '500',
                      fillColor: AppColors.lightGreyColor2,
                      borderRadius: 16.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const CreateEventVenuePicker(),
          SizedBox(height: 20.h),
          TextProperty(
            text: 'Description',
            textColor: AppColors.blackColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 6.h),
          CustomTextfield(
            controller: controller.descriptionController,
            fieldText:
                'Describe the event — vibe, what to expect, special features...',
            hintTextColor: AppColors.lightGreyColor,
            maxLines: 5,
            fillColor: AppColors.lightGreyColor2,
            borderRadius: 16.r,
          ),
        ],
      ),
    );
  }
}
