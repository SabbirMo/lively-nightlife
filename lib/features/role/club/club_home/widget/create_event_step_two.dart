import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_create_event_controller.dart';

class CreateEventStepTwo extends GetView<ClubCreateEventController> {
  const CreateEventStepTwo({super.key});

  static const List<String> genres = [
    'EDM', 'Hip Hop', 'Latin', 'House', 'Techno', 'Open Format', 'R&B',
    'Reggaeton', 'Live Music', 'Jazz', 'College', 'Trap'
  ];

  static const List<String> ages = ['18+', '21+', 'All Ages'];

  static const List<String> dressCodes = [
    'Upscale Nightclub', 'Casual', 'Smart Casual', 'Rave / Creative',
    'Pool Attire', 'Black Tie', 'No Dress Code'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Genres * (select all that apply)'),
          SizedBox(height: 8.h),
          Obx(() => Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: genres.map((genre) {
              final isSelected = controller.selectedGenres.contains(genre);
              return _buildPill(
                label: genre,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected) {
                    controller.selectedGenres.remove(genre);
                  } else {
                    controller.selectedGenres.add(genre);
                  }
                },
              );
            }).toList(),
          )),
          SizedBox(height: 20.h),
          _buildSectionTitle('Age Restriction'),
          SizedBox(height: 8.h),
          Obx(() => Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: ages.map((age) {
              final isSelected = controller.selectedAge.value == age;
              return _buildPill(
                label: age,
                isSelected: isSelected,
                onTap: () => controller.selectedAge.value = age,
              );
            }).toList(),
          )),
          SizedBox(height: 20.h),
          _buildSectionTitle('Dress Code'),
          SizedBox(height: 8.h),
          Obx(() => Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: dressCodes.map((code) {
              final isSelected = controller.selectedDressCode.value == code;
              return _buildPill(
                label: code,
                isSelected: isSelected,
                onTap: () => controller.selectedDressCode.value = code,
              );
            }).toList(),
          )),
          SizedBox(height: 20.h),
          _buildSectionTitle('Tags'),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: CustomTextfield(
                  controller: controller.eventTagController,
                  fieldText: 'Add a tag...',
                  hintTextColor: AppColors.lightGreyColor,
                  fillColor: AppColors.lightGreyColor2,
                  borderRadius: 16.r,
                ),
              ),
              SizedBox(width: 12.w),
              ElevatedButton(
                onPressed: controller.addTag,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                ),
                child: TextProperty(
                  text: 'Add',
                  textColor: AppColors.whiteColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(() => Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: controller.eventTags.map((tag) {
              return Chip(
                label: TextProperty(
                  text: tag,
                  textColor: AppColors.primaryColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
                backgroundColor: AppColors.primaryColor.withValues(alpha: 0.08),
                side: const BorderSide(color: Colors.transparent),
                onDeleted: () => controller.eventTags.remove(tag),
                deleteIconColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return TextProperty(
      text: title,
      textColor: AppColors.blackColor,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.08)
              : AppColors.lightGreyColor2,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.grey50Color,
            width: 1.w,
          ),
        ),
        child: TextProperty(
          text: label,
          textColor: isSelected ? AppColors.primaryColor : AppColors.greyColor,
          fontSize: 13.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
