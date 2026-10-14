import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_chat_controller.dart';
import '../model/user_story_model.dart';

class UserChatStoriesWidget extends StatelessWidget {
  const UserChatStoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserChatController>();

    return SizedBox(
      height: 100.h,
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.stories.length,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemBuilder: (context, index) {
            final story = controller.stories[index];
            return Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: _StoryItem(story: story, controller: controller),
            );
          },
        );
      }),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final UserStoryModel story;
  final UserChatController controller;

  const _StoryItem({
    required this.story,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (story.isYourStory) {
              _showStoryPickerDialog(context);
            } else {
              _showViewStoryDialog(context, story);
            }
          },
          child: story.isYourStory && story.mediaPath == null
              ? Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: AppColors.blackColor,
                      size: 28.sp,
                    ),
                  ),
                )
              : DottedBorder(
                  options: CircularDottedBorderOptions(
                    color: AppColors.blueColor,
                    strokeWidth: 2.w,
                    dashPattern: const [8, 4],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(3.r),
                    child: CircleAvatar(
                      radius: 26.r,
                      backgroundColor: AppColors.grey50Color,
                      backgroundImage: story.mediaPath != null
                          ? FileImage(File(story.mediaPath!)) as ImageProvider
                          : NetworkImage(story.avatar),
                    ),
                  ),
                ),
        ),
        SizedBox(height: 6.h),
        TextProperty(
          text: story.name,
          textColor: AppColors.secondBlackColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  void _showStoryPickerDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGreyColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            TextProperty(
              text: 'Upload Story',
              textColor: AppColors.blackColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: AppColors.grey50Color,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.camera_alt, color: AppColors.primaryColor, size: 20.sp),
              ),
              title: TextProperty(
                text: 'Capture Photo',
                textColor: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              onTap: () {
                Get.back();
                controller.createStory(true, isVideo: false);
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: AppColors.grey50Color,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.videocam, color: AppColors.primaryColor, size: 20.sp),
              ),
              title: TextProperty(
                text: 'Capture Video',
                textColor: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              onTap: () {
                Get.back();
                controller.createStory(true, isVideo: true);
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: AppColors.grey50Color,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.photo_library, color: AppColors.primaryColor, size: 20.sp),
              ),
              title: TextProperty(
                text: 'Pick from Gallery',
                textColor: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              onTap: () {
                Get.back();
                controller.createStory(false, isVideo: false);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  void _showViewStoryDialog(BuildContext context, UserStoryModel story) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.9),
                child: story.mediaPath != null
                    ? Image.file(
                        File(story.mediaPath!),
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        story.avatar,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            Positioned(
              top: 40.h,
              left: 20.w,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(story.avatar),
                    radius: 20.r,
                  ),
                  SizedBox(width: 10.w),
                  TextProperty(
                    text: story.name,
                    textColor: AppColors.whiteColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40.h,
              right: 20.w,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.whiteColor),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
