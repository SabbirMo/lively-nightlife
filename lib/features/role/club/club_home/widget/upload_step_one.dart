import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_upload_content_controller.dart';

class UploadStepOne extends GetView<ClubUploadContentController> {
  const UploadStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: controller.pickImages,
                child: Obx(() {
                  if (controller.selectedImagePaths.isEmpty) {
                    return Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreyColor2,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.lightGreyColor,
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColors.lightGreyColor,
                            size: 24.sp,
                          ),
                          SizedBox(height: 4.h),
                          TextProperty(
                            text: 'Upload',
                            textColor: AppColors.lightGreyColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.file(
                            File(controller.selectedImagePaths.first),
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (controller.selectedImagePaths.length > 1)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.r),
                                  bottomRight: Radius.circular(16.r),
                                ),
                              ),
                              child: TextProperty(
                                text: '+${controller.selectedImagePaths.length - 1}',
                                textColor: AppColors.whiteColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                }),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomTextfield(
                  controller: controller.captionController,
                  fieldText: "What's the vibe tonight? Tell your story...",
                  maxLines: 5,
                  fillColor: Colors.transparent,
                  borderRadius: 12.r,
                  hintTextColor: AppColors.lightGreyColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => TextProperty(
                text: '${controller.captionLength.value}/2200',
                textColor: AppColors.lightGreyColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          TextProperty(
            text: 'Add mood',
            textColor: AppColors.lightGreyColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 12.h),
          Obx(() {
            return Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: controller.moods.map((mood) {
                final isSelected = controller.selectedMood.value == mood;
                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      controller.selectedMood.value = '';
                    } else {
                      controller.selectedMood.value = mood;
                    }
                  },
                  child: Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.1)
                          : AppColors.lightGreyColor2,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.primaryColor : Colors.transparent,
                        width: 1.5.w,
                      ),
                    ),
                    child: Center(
                      child: Text(mood, style: TextStyle(fontSize: 22.sp)),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
