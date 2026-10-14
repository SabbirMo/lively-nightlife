import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_chat_model.dart';
import '../controller/club_chat_controller.dart';
import '../widget/club_chat_message_bubble.dart';

class ClubChatScreenView extends StatelessWidget {
  const ClubChatScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClubChatController>();

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            ImagePath.bluehighlightedBackground2,
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
                  _buildHeader(chat),
                  Container(
                    height: 1.h,
                    color: AppColors.lightGreyColor.withValues(alpha: 0.15),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.r),
                      reverse: true,
                      itemCount: chat.messages.length,
                      itemBuilder: (context, index) {
                        final message = chat.messages.reversed.toList()[index];
                        return ClubChatMessageBubble(message: message);
                      },
                    ),
                  ),
                  _buildBottomInputBar(context, controller),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeader(UserChatModel chat) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: SvgPicture.asset(
              IconPath.backButton,
              width: 16.w,
              height: 16.h,
              colorFilter: const ColorFilter.mode(AppColors.secondBlackColor, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 12.w),
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.grey50Color,
            backgroundImage: NetworkImage(chat.avatar),
          ),
          SizedBox(width: 12.w),
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
                  text: chat.isOnline ? 'Active now' : chat.lastSeen,
                  textColor: AppColors.greyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInputBar(BuildContext context, ClubChatController controller) {
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
          GestureDetector(
            onTap: () => controller.pickFileAttachment(sentByClub: true),
            child: Container(
              padding: EdgeInsets.all(8.r),
              child: SvgPicture.asset(IconPath.addIcon, width: 20.w, height: 20.h),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomTextfield(
              controller: controller.messageInputController,
              fillColor: AppColors.whiteColor,
              fieldText: 'Type Chat Here...',
              suffixIcon: GestureDetector(
                onTap: () {
                  controller.sendMessage(
                    controller.messageInputController.text,
                    sentByClub: true,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: SvgPicture.asset(IconPath.sendIcon, width: 20.w, height: 20.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => controller.pickImageAttachment(false, sentByClub: true),
            child: Container(
              padding: EdgeInsets.all(8.r),
              child: SvgPicture.asset(IconPath.cameraIcon, width: 20.w, height: 20.h),
            ),
          ),
        ],
      ),
    );
  }
}
