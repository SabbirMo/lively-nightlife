import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_chat_model.dart';
import '../controller/club_chat_controller.dart';
import 'club_chat_screen_view.dart';

class ClubChatInboxView extends StatelessWidget {
  const ClubChatInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClubChatController());

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            ImagePath.bluehighlightedBackground2,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
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
                      TextProperty(
                        text: 'Messages',
                        textColor: AppColors.secondBlackColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: Obx(() {
                    final chats = controller.chatsList.where((c) => !c.isClub).toList();
                    if (chats.isEmpty) {
                      return Center(
                        child: TextProperty(
                          text: 'No conversations found',
                          textColor: AppColors.greyColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
                      itemCount: chats.length,
                      separatorBuilder: (context, index) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return _buildChatItem(context, chat, controller);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(
    BuildContext context,
    UserChatModel chat,
    ClubChatController controller,
  ) {
    return GestureDetector(
      onTap: () {
        controller.selectChat(chat);
        Get.to(() => const ClubChatScreenView());
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColors.grey50Color,
              backgroundImage: NetworkImage(chat.avatar),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextProperty(
                    text: chat.name,
                    textColor: AppColors.secondBlackColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 4.h),
                  TextProperty(
                    text: chat.messages.isNotEmpty
                        ? (chat.messages.last.sentByClub
                            ? 'You: ${chat.messages.last.text}'
                            : chat.messages.last.text)
                        : 'Start chatting',
                    textColor: AppColors.greyColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            TextProperty(
              text: chat.time,
              textColor: AppColors.greyColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
