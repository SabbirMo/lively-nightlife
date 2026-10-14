import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_upload_content_controller.dart';

class UploadStepThree extends GetView<ClubUploadContentController> {
  const UploadStepThree({super.key});

  Widget _buildPreviewImages() {
    final List<String> images = controller.selectedImagePaths.isNotEmpty
        ? controller.selectedImagePaths
        : [ImagePath.feedImage];

    if (images.length == 1) {
      final imagePath = images.first;
      return ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: imagePath.startsWith('assets/')
            ? Image.asset(
                imagePath,
                width: double.infinity,
                height: 280.h,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(imagePath),
                width: double.infinity,
                height: 280.h,
                fit: BoxFit.cover,
              ),
      );
    }

    final activeIndex = 0.obs;
    return SizedBox(
      height: 280.h,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (index) => activeIndex.value = index,
              itemBuilder: (context, index) {
                final imagePath = images[index];
                return imagePath.startsWith('assets/')
                    ? Image.asset(
                        imagePath,
                        width: double.infinity,
                        height: 280.h,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(imagePath),
                        width: double.infinity,
                        height: 280.h,
                        fit: BoxFit.cover,
                      );
              },
            ),
          ),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Obx(
                () => TextProperty(
                  text: '${activeIndex.value + 1}/${images.length}',
                  textColor: AppColors.whiteColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: TextProperty(
              text: 'Preview your post',
              textColor: AppColors.lightGreyColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor2,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.grey50Color, width: 1.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 19,
                      backgroundColor: AppColors.purpleColor,
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundImage: const NetworkImage(
                          'https://i.pravatar.cc/150?img=60',
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextProperty(
                            text: 'alex_nights',
                            textColor: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(height: 2.h),
                          TextProperty(
                            text: 'Just now',
                            textColor: AppColors.lightGreyColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildPreviewImages(),
                SizedBox(height: 12.h),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'alex_nights ',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: controller.captionController.text.isNotEmpty
                            ? controller.captionController.text
                            : 'No caption provided',
                        style: TextStyle(
                          color: AppColors.secondBlackColor,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.selectedTags.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  TextProperty(
                    text: controller.selectedTags
                        .map((tag) => '#$tag')
                        .join(' '),
                    textColor: AppColors.blueColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
                if (controller.taggedPeople.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  TextProperty(
                    text:
                        'Tagged: ${controller.taggedPeople.map((name) => '@$name').join(', ')}',
                    textColor: AppColors.purpleColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(
                          () => SvgPicture.asset(
                            controller.visibility.value == 'Public'
                                ? IconPath.globalIcon
                                : controller.visibility.value == 'Followers'
                                ? IconPath.purplePerson
                                : IconPath.lock,
                            width: 14.w,
                            height: 14.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.lightGreyColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Obx(
                          () => TextProperty(
                            text: controller.visibility.value,
                            textColor: AppColors.lightGreyColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    TextProperty(
                      text: 'Just now',
                      textColor: AppColors.lightGreyColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
