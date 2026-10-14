import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/controller/user_chat_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_chat_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_chat_view/model/user_message_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/model/user_discover_club_model.dart';
import 'package:share_plus/share_plus.dart';
import '../model/user_event_model.dart';

class UserEventShareBottomSheet extends StatefulWidget {
  final UserEventModel event;

  const UserEventShareBottomSheet({super.key, required this.event});

  @override
  State<UserEventShareBottomSheet> createState() => _UserEventShareBottomSheetState();
}

class _UserEventShareBottomSheetState extends State<UserEventShareBottomSheet> {
  final Set<String> _sentUsers = {};
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _friends = [
    {
      'name': 'Alex',
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
    },
    {
      'name': 'Emma',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    },
    {
      'name': 'Ryan',
      'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    },
    {
      'name': 'Sophia',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    },
    {
      'name': 'John',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter friends list based on search query
    final filteredFriends = _friends.where((friend) {
      return friend['name']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.defaultBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(
          color: AppColors.whiteColor.withValues(alpha: 0.1),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: AppColors.lightGreyColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),

          // Header
          Center(
            child: TextProperty(
              text: 'Share Event',
              textColor: AppColors.whiteColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20.h),

          // Quick Share Row (Copy Link & Share Externally)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Copied',
                      'Event link copied successfully',
                      backgroundColor: AppColors.blueColor,
                      colorText: AppColors.whiteColor,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.whiteColor.withValues(alpha: 0.1),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: AppColors.blueColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.link,
                            color: AppColors.blueColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextProperty(
                          text: 'Copy Link',
                          textColor: AppColors.whiteColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    Share.share(
                      'Check out "${widget.event.name}" at ${widget.event.location} on ${widget.event.date}!',
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.whiteColor.withValues(alpha: 0.1),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.share,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextProperty(
                          text: 'Share Externally',
                          textColor: AppColors.whiteColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Share inside app header
          TextProperty(
            text: 'Share Inside App',
            textColor: AppColors.whiteColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 12.h),

          // Search Field
          TextField(
            controller: _searchController,
            style: const TextStyle(color: AppColors.whiteColor),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              hintText: 'Search friends...',
              hintStyle: TextStyle(
                color: AppColors.lightGreyColor.withValues(alpha: 0.6),
                fontSize: 13.sp,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.lightGreyColor,
              ),
              filled: true,
              fillColor: AppColors.whiteColor.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.whiteColor.withValues(alpha: 0.1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.whiteColor.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.blueColor,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          SizedBox(height: 16.h),

          // Friends List
          SizedBox(
            height: 220.h,
            child: filteredFriends.isEmpty
                ? Center(
                    child: TextProperty(
                      text: 'No friends found',
                      textColor: AppColors.lightGreyColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredFriends.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (_, index) {
                      final friend = filteredFriends[index];
                      final userName = friend['name']!;
                      final userAvatar = friend['avatar']!;
                      final isSent = _sentUsers.contains(userName);

                      return Row(
                        children: [
                          // Glow avatar with green active status indicator
                          Stack(
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.blueColor.withValues(alpha: 0.3),
                                    width: 1.5.w,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage: NetworkImage(userAvatar),
                                ),
                              ),
                              Positioned(
                                right: 1.w,
                                bottom: 1.w,
                                child: Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.defaultBackgroundColor,
                                      width: 1.5.r,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 14.w),

                          // Friend Name
                          Expanded(
                            child: TextProperty(
                              text: userName,
                              textColor: AppColors.whiteColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          // Send/Sent Interactive Button
                          GestureDetector(
                            onTap: isSent
                                ? null
                                : () {
                                    setState(() {
                                      _sentUsers.add(userName);
                                    });

                                    // Convert UserEventModel to UserDiscoverClubModel representation
                                    int evId = 1;
                                    try {
                                      evId = int.parse(widget.event.id);
                                    } catch (_) {}

                                    final sharedItem = UserDiscoverClubModel(
                                      id: evId,
                                      name: widget.event.name,
                                      rating: 5.0,
                                      location: widget.event.location,
                                      priceRange: '\$${widget.event.price}',
                                      categories: widget.event.categories,
                                      followersCount: '0',
                                      upcomingEventsCount: 0,
                                      capacity: 'N/A',
                                      isOpenNow: true,
                                      image: widget.event.image,
                                      type: 'event',
                                    );

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
                                          avatar: userAvatar,
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
                                        text: 'Shared an event: ${widget.event.name}',
                                        isMe: true,
                                        time: DateTime.now(),
                                        sharedClubOrEvent: sharedItem,
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
                                      'Event shared with $userName successfully!',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: AppColors.blueColor,
                                      colorText: AppColors.whiteColor,
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSent
                                    ? null
                                    : const LinearGradient(
                                        colors: [
                                          AppColors.primaryColor,
                                          AppColors.blueColor,
                                        ],
                                      ),
                                color: isSent
                                    ? AppColors.whiteColor.withValues(alpha: 0.1)
                                    : null,
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSent) ...[
                                    Icon(
                                      Icons.check,
                                      color: AppColors.lightGreyColor,
                                      size: 14.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                  ],
                                  TextProperty(
                                    text: isSent ? 'Sent' : 'Send',
                                    textColor: isSent
                                        ? AppColors.lightGreyColor
                                        : AppColors.whiteColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
