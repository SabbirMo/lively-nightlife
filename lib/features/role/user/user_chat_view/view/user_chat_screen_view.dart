import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import '../controller/user_chat_controller.dart';
import '../widget/user_chat_message_bubble.dart';

class UserChatScreenView extends StatelessWidget {
  const UserChatScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserChatController>();

    return Scaffold(
      body: Stack(
        children: [
          // Blue Highlighted Background
          Image.asset(
            ImagePath.bluehighlightedBackground,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Obx(() {
            final chat = controller.activeChat.value;
            if (chat == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        // Back Button
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: SvgPicture.asset(
                            IconPath.backButton,
                            width: 16.w,
                            height: 16.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.secondBlackColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Friend Avatar
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: AppColors.grey50Color,
                          backgroundImage: NetworkImage(chat.avatar),
                        ),
                        SizedBox(width: 12.w),
                        // Friend Name & Status
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextProperty(
                                text: chat.name,
                                textColor: AppColors.secondBlackColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: 2.h),
                              TextProperty(
                                text: chat.isOnline
                                    ? 'Active now'
                                    : chat.lastSeen,
                                textColor: AppColors.greyColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider Line
                  Container(
                    height: 1.h,
                    color: AppColors.lightGreyColor.withValues(alpha: 0.15),
                  ),

                  // Messages Stream
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.r),
                      reverse: true,
                      itemCount: chat.messages.length,
                      itemBuilder: (context, index) {
                        // Reverse index to show latest messages at bottom
                        final message = chat.messages.reversed.toList()[index];
                        return UserChatMessageBubble(message: message);
                      },
                    ),
                  ),

                  // Bottom Message Input Bar
                  chat.isClub
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
                          margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 12.h : 24.h,
                            left: 16.w,
                            right: 16.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.grey50Color,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.lightGreyColor.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_outline, color: AppColors.greyColor, size: 16.w),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextProperty(
                                  text: 'Only clubs can send messages in this chat.',
                                  textColor: AppColors.greyColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildBottomInputBar(context, controller),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomInputBar(
    BuildContext context,
    UserChatController controller,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 12.h,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 12.h : 24.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withValues(alpha: 0.65),
      ),
      child: Row(
        children: [
          // Attachment Plus Button
          GestureDetector(
            onTap: () => controller.pickFileAttachment(),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: SvgPicture.asset(
                IconPath.addIcon,
                width: 20.w,
                height: 20.h,
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // CustomTextfield wrapped in Expanded
          Expanded(
            child: CustomTextfield(
              controller: controller.messageInputController,
              fillColor: AppColors.whiteColor,
              fieldText: 'Type Chat Here...',
              // borderRadius: 30.r,
              suffixIcon: GestureDetector(
                onTap: () {
                  controller.sendMessage(
                    controller.messageInputController.text,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: SvgPicture.asset(
                    IconPath.sendIcon,
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // Camera Button
          GestureDetector(
            onTap: () => _showImageAttachmentOptions(context, controller),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: SvgPicture.asset(
                IconPath.cameraIcon,
                width: 20.w,
                height: 20.h,
                // colorFilter: const ColorFilter.mode(
                //   AppColors.primaryColor,
                //   BlendMode.srcIn,
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageAttachmentOptions(
    BuildContext context,
    UserChatController controller,
  ) {
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
              text: 'Send Photo',
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
                child: Icon(
                  Icons.camera_alt,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
              title: TextProperty(
                text: 'Snap with Camera',
                textColor: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              onTap: () {
                Get.back();
                controller.pickImageAttachment(true);
              },
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: AppColors.grey50Color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.photo_library,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
              title: TextProperty(
                text: 'Choose from Gallery',
                textColor: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              onTap: () {
                Get.back();
                controller.pickImageAttachment(false);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
