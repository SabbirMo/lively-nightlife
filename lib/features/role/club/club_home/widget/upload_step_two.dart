import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_upload_content_controller.dart';
import 'upload_visibility_selector.dart';

class UploadStepTwo extends GetView<ClubUploadContentController> {
  const UploadStepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextProperty(
            text: 'Tag Location',
            textColor: AppColors.lightGreyColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8.h),
          CustomTextfield(
            controller: controller.locationController,
            hintTextColor: AppColors.greyColor,
            fieldText: 'Add location or venue...',
            prefixIcon: IconPath.insaneLocationIcon,
            fillColor: AppColors.lightGreyColor2,
            borderRadius: 16.r,
          ),
          SizedBox(height: 20.h),
          Obx(
            () => TextProperty(
              text: 'Add Tags (${controller.selectedTags.length}/10)',
              textColor: AppColors.lightGreyColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          CustomTextfield(
            controller: controller.tagController,
            fieldText: 'Type a tag and press Enter...',
            prefixIcon: IconPath.purpleTagIcon,
            hintTextColor: AppColors.greyColor,
            fillColor: AppColors.lightGreyColor2,
            borderRadius: 16.r,
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.purpleColor),
              onPressed: controller.addCustomTag,
            ),
          ),
          SizedBox(height: 12.h),
          Obx(() {
            if (controller.selectedTags.isEmpty) return const SizedBox.shrink();
            return Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: controller.selectedTags.map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blueColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextProperty(
                        text: tag,
                        textColor: AppColors.whiteColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: () => controller.selectedTags.remove(tag),
                        child: Icon(
                          Icons.close,
                          size: 14.sp,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: controller.tagSuggestions.map((tag) {
              return Obx(() {
                final isSelected = controller.selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => controller.toggleSuggestedTag(tag),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.1)
                          : AppColors.lightGreyColor2,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: TextProperty(
                      text: '+ $tag',
                      textColor: isSelected
                          ? AppColors.primaryColor
                          : AppColors.greyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              });
            }).toList(),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: controller.showTagPeopleDialog,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.lightGreyColor2,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.alternate_email,
                    color: AppColors.purpleColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(() {
                      if (controller.taggedPeople.isEmpty) {
                        return TextProperty(
                          text: 'Tag people',
                          textColor: AppColors.lightGreyColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        );
                      } else {
                        return TextProperty(
                          text: 'Tagged: ${controller.taggedPeople.join(', ')}',
                          textColor: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                    }),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.lightGreyColor,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          const UploadVisibilitySelector(),
        ],
      ),
    );
  }
}
