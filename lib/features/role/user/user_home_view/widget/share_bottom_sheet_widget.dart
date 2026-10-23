import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/controller/user_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/model/feed_post_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/controller/user_chat_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_chat_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_message_model.dart';

class ShareableUser {
  final String id;
  final String name;
  final String? avatar;

  const ShareableUser({required this.id, required this.name, this.avatar});
}

class ShareBottomSheetWidget extends StatelessWidget {
  final FeedPostModel post;

  const ShareBottomSheetWidget({super.key, required this.post});

  List<ShareableUser> _getShareableUsers() {
    final List<ShareableUser> list = [];
    final Set<String> seen = {};

    // 1. From UserChatController (Recent chats)
    if (Get.isRegistered<UserChatController>()) {
      final chatController = Get.find<UserChatController>();
      for (final chat in chatController.chatsList) {
        final name = chat.name.trim();
        final key = name.toLowerCase();
        if (name.isNotEmpty && !seen.contains(key)) {
          seen.add(key);
          list.add(ShareableUser(id: chat.id, name: name, avatar: chat.avatar));
        }
      }
    }

    // 2. From UserHomeController (Following posts & feed authors)
    if (Get.isRegistered<UserHomeController>()) {
      final homeController = Get.find<UserHomeController>();

      // First add from Following posts
      for (final p in homeController.followingPosts) {
        final name = p.userName.trim();
        final key = name.toLowerCase();
        if (name.isNotEmpty && !seen.contains(key)) {
          seen.add(key);
          list.add(
            ShareableUser(
              id: p.id.toString(),
              name: name,
              avatar: p.profileImage,
            ),
          );
        }
      }

      // Then add from For-You & Nearby posts
      for (final p in [
        ...homeController.forYouPosts,
        ...homeController.nearbyPosts,
      ]) {
        final name = p.userName.trim();
        final key = name.toLowerCase();
        if (name.isNotEmpty && !seen.contains(key)) {
          seen.add(key);
          list.add(
            ShareableUser(
              id: p.id.toString(),
              name: name,
              avatar: p.profileImage,
            ),
          );
        }
      }
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<UserHomeController>()
        ? Get.find<UserHomeController>()
        : Get.put(UserHomeController());

    final chatController = Get.isRegistered<UserChatController>()
        ? Get.find<UserChatController>()
        : Get.put(UserChatController());

    final users = _getShareableUsers();

    final colors = [
      const Color(0xFFC084FC), // Purple
      const Color(0xFFF472B6), // Pink
      const Color(0xFF60A5FA), // Blue
      const Color(0xFF34D399), // Green
      const Color(0xFFFBBF24), // Amber
      const Color(0xFFF87171), // Red
      const Color(0xFF2DD4BF), // Teal
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20.r,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 48.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Title
          TextProperty(
            text: 'Share Post',
            textColor: AppColors.blackColor,
            fontFamily: 'Sora',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 24.h),

          // Two Quick Action Cards (Side by side)
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.share_outlined,
                  label: 'Share Externally',
                  color: AppColors.blueColor,
                  bgColor: AppColors.blueColor.withValues(alpha: 0.08),
                  onTap: () async {
                    Get.back();
                    homeController.sharePost(post);

                    final buffer = StringBuffer();
                    if (post.caption.isNotEmpty) {
                      buffer.writeln(post.caption);
                    }
                    if (post.hashtags.isNotEmpty) {
                      buffer.writeln(post.hashtags);
                    }
                    final details = <String>[];
                    if (post.userName.isNotEmpty) {
                      details.add('by @${post.userName}');
                    }
                    if (post.location.isNotEmpty) {
                      details.add('at ${post.location}');
                    }
                    if (details.isNotEmpty) {
                      buffer.writeln(details.join(' '));
                    }
                    if (post.image.isNotEmpty &&
                        (post.image.startsWith('http://') ||
                            post.image.startsWith('https://'))) {
                      buffer.writeln('\n${post.image}');
                    }
                    buffer.writeln('\nShared via Lively Nightlife');

                    // ignore: deprecated_member_use
                    await Share.share(
                      buffer.toString().trim(),
                      subject: post.caption.isNotEmpty
                          ? post.caption
                          : 'Post by @${post.userName} on Lively',
                    );
                  },
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.link_outlined,
                  label: 'Copy Link',
                  color: AppColors.grey700Color,
                  bgColor: AppColors.grey50Color.withValues(alpha: 0.5),
                  onTap: () async {
                    Get.back();
                    homeController.sharePost(post);

                    final link =
                        (post.image.isNotEmpty &&
                            (post.image.startsWith('http://') ||
                                post.image.startsWith('https://')))
                        ? post.image
                        : 'https://livelynightlife.app/post/${post.id}';

                    await Clipboard.setData(ClipboardData(text: link));

                    Get.snackbar(
                      'Copied',
                      'Link copied successfully',
                      backgroundColor: AppColors.blueColor,
                      colorText: AppColors.whiteColor,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 28.h),

          // Section Title
          Align(
            alignment: Alignment.centerLeft,
            child: TextProperty(
              text: 'Share Inside App',
              textColor: AppColors.blackColor,
              fontFamily: 'Sora',
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),

          // Horizontal Contacts List (Real users from Following / Chats)
          if (users.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(
                child: TextProperty(
                  text: 'No contacts or following users found',
                  textColor: AppColors.greyColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          else
            SizedBox(
              height: 90.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final Color avatarColor = colors[index % colors.length];
                  final bool hasAvatar =
                      user.avatar != null &&
                      user.avatar!.isNotEmpty &&
                      (user.avatar!.startsWith('http://') ||
                          user.avatar!.startsWith('https://'));

                  return GestureDetector(
                    onTap: () {
                      Get.back();
                      homeController.sharePost(post);

                      final msgText =
                          'Check out this post by @${post.userName} at ${post.location}: "${post.caption}"';

                      final cIdx = chatController.chatsList.indexWhere(
                        (c) => c.name.toLowerCase().contains(
                          user.name.toLowerCase(),
                        ),
                      );
                      UserChatModel chat;
                      if (cIdx != -1) {
                        chat = chatController.chatsList[cIdx];
                      } else {
                        chat = UserChatModel(
                          id: user.id.isNotEmpty
                              ? user.id
                              : DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                          name: user.name,
                          avatar: hasAvatar
                              ? user.avatar!
                              : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
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

                      Get.snackbar(
                        'Shared Inside App',
                        'Post shared with ${user.name} successfully!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.blueColor,
                        colorText: AppColors.whiteColor,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 18.w),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 26.r,
                            backgroundColor: avatarColor.withValues(
                              alpha: 0.15,
                            ),
                            backgroundImage: hasAvatar
                                ? NetworkImage(user.avatar!)
                                : null,
                            child: !hasAvatar
                                ? TextProperty(
                                    text: user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : 'U',
                                    textColor: avatarColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                  )
                                : null,
                          ),
                          SizedBox(height: 6.h),
                          SizedBox(
                            width: 60.w,
                            child: TextProperty(
                              text: user.name,
                              textColor: AppColors.greyColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(height: 8.h),
            TextProperty(
              text: label,
              textColor: AppColors.blackColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
