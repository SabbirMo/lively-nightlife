import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/controller/heat_map_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/model/club_post_model.dart';

import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/controller/user_chat_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_chat_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_message_model.dart';

class HeatPostShareBottomSheet extends StatelessWidget {
  final ClubPostModel post;

  const HeatPostShareBottomSheet({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HeatMapController>();

    final users = ['Alex', 'Emma', 'Ryan', 'Sophia', 'John'];

    return Container(
      padding: EdgeInsets.all(20.w),

      decoration: BoxDecoration(
        color: AppColors.whiteColor,

        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          TextProperty(
            text: 'Share Post',
            textColor: AppColors.blackColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),

          SizedBox(height: 20.h),

          ListTile(
            onTap: controller.shareExternally,
            leading: const Icon(Icons.share),
            title: TextProperty(
              text: 'Share Externally',
              textColor: AppColors.blackColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          ListTile(
            onTap: () {
              Get.back();

              Get.snackbar('Copied', 'Link copied successfully');
            },
            leading: const Icon(Icons.link),
            title: TextProperty(
              text: 'Copy Link',
              textColor: AppColors.blackColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 10.h),

          Align(
            alignment: Alignment.centerLeft,
            child: TextProperty(
              text: 'Share Inside App',
              textColor: AppColors.blackColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 10.h),

          SizedBox(
            height: 200.h,

            child: ListView.builder(
              itemCount: users.length,

              itemBuilder: (_, index) {
                return ListTile(
                  onTap: () {
                    Get.back();
                    final userName = users[index];

                    final msgText =
                        'Check out this post: "${post.caption}" (posted ${post.time})';
                    if (Get.isRegistered<UserChatController>()) {
                      final chatController = Get.find<UserChatController>();
                      final cIdx = chatController.chatsList.indexWhere(
                        (c) => c.name.toLowerCase().contains(
                          userName.toLowerCase(),
                        ),
                      );
                      UserChatModel chat;
                      if (cIdx != -1) {
                        chat = chatController.chatsList[cIdx];
                      } else {
                        chat = UserChatModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: userName,
                          avatar:
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
                          lastSeen: 'Active now',
                          isOnline: true,
                          time: 'Just now',
                          unreadCount: 0,
                          messages: [],
                        );
                        chatController.chatsList.add(chat);
                      }

                      final newMessage = UserMessageModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        text: msgText,
                        isMe: true,
                        time: DateTime.now(),
                      );

                      final updatedMessages = List<UserMessageModel>.from(
                        chat.messages,
                      )..add(newMessage);
                      final updatedChat = chat.copyWith(
                        messages: updatedMessages,
                        time: 'Just now',
                      );

                      final targetIdx = chatController.chatsList.indexWhere(
                        (c) => c.name == chat.name,
                      );
                      if (targetIdx != -1) {
                        chatController.chatsList[targetIdx] = updatedChat;
                      }
                      chatController.filterChats();
                    }

                    Get.snackbar(
                      'Shared Inside App',
                      'Post shared with $userName successfully!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.blueColor,
                      colorText: AppColors.whiteColor,
                    );
                  },

                  leading: Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImagePath.feedImage),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                    // padding: const EdgeInsets.all(8),
                    // child: SvgPicture.asset(
                    //   IconPath.userAvatar,
                    //   fit: BoxFit.contain,
                    // ),
                  ),

                  // CircleAvatar(
                  //   // backgroundColor: AppColors.blueColor,
                  //   // TextProperty(
                  //   //   text: users[index][0],
                  //   //   textColor: AppColors.whiteColor, fontSize: 16.sp, fontWeight: FontWeight.w500,
                  //   // ),
                  // ),
                  title: TextProperty(
                    text: users[index],
                    textColor: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
