import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/bottom_navigation_bar/controllers/user_bottom_navigation_bar_controller.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import '../controller/user_chat_controller.dart';
import '../model/user_chat_model.dart';
import '../widget/user_chat_filter_tab_bar.dart';
import '../widget/user_chat_stories_widget.dart';

class UserChatInboxView extends StatelessWidget {
  const UserChatInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject or find controller
    final controller = Get.put(UserChatController());
    final bottomNavController = Get.find<UserBottomNavbarController>();

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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Top Bar Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () {
                          // Change bottom navbar tab to Home (index 0)
                          bottomNavController.changeTab(0);
                        },
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
                      SizedBox(width: 8.w),
                      // Title
                      TextProperty(
                        text: 'Lively',
                        textColor: AppColors.secondBlackColor,
                        fontFamily: 'Sora',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      const Spacer(),
                      // Notification bell with red badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Get.toNamed(AppRoute.userNotificationView),
                            child: SvgPicture.asset(
                              IconPath.notificationBellIcon,
                              width: 24.w,
                              height: 24.h,
                            ),
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 16.w,
                              height: 16.h,
                              decoration: const BoxDecoration(
                                color: AppColors.redColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: TextProperty(
                                text: '4',
                                textColor: AppColors.whiteColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      // Profile Avatar with green active indicator dot
                      Stack(
                        children: [
                          Container(
                            width: 38.w,
                            height: 38.h,
                            decoration: const BoxDecoration(
                              color: AppColors.grey50Color,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 18.r,
                              backgroundImage: const NetworkImage(
                                'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6',
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 10.w,
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.whiteColor,
                                  width: 1.5.r,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // Stories list
                const UserChatStoriesWidget(),
                SizedBox(height: 20.h),

                // Filters tab bar
                const UserChatFilterTabBar(),
                SizedBox(height: 20.h),

                // Active chats list
                Expanded(
                  child: Obx(() {
                    if (controller.filteredChats.isEmpty) {
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
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 20.h,
                      ),
                      itemCount: controller.filteredChats.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final chat = controller.filteredChats[index];
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
    UserChatController controller,
  ) {
    final hasUnread = chat.unreadCount > 0;

    return GestureDetector(
      onTap: () {
        controller.selectChat(chat);
        Get.toNamed(AppRoute.userChatScreenView);
      },
      child: Row(
        children: [
          // Avatar Stack (with blue status dot if unread)
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.grey50Color,
                backgroundImage: NetworkImage(chat.avatar),
              ),
              if (hasUnread)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 14.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.blueColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.whiteColor,
                        width: 2.r,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 14.w),
          // Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextProperty(
                  text: chat.name,
                  textColor: AppColors.secondBlackColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 4.h),
                TextProperty(
                  text: chat.messages.isNotEmpty
                      ? (chat.messages.last.isMe
                            ? 'You: ${chat.messages.last.text}'
                            : chat.messages.last.text)
                      : 'Start chatting',
                  textColor: hasUnread
                      ? AppColors.blackColor
                      : AppColors.greyColor,
                  fontSize: 13.sp,
                  fontWeight: hasUnread ? FontWeight.bold : FontWeight.w400,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          // Time text
          TextProperty(
            text: chat.time,
            textColor: AppColors.greyColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
