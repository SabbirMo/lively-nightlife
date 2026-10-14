import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/model/user_discover_club_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/controller/user_event_controller.dart';
import '../model/user_message_model.dart';

class UserChatMessageBubble extends StatelessWidget {
  final UserMessageModel message;
  final bool isClubView;

  const UserChatMessageBubble({
    super.key,
    required this.message,
    this.isClubView = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = isClubView ? message.sentByClub : message.isMe;

    if (message.sharedClubOrEvent != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: isMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [_buildSharedEventCard(message.sharedClubOrEvent!)],
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: TextProperty(
                text: _formatTime(message.time),
                textColor: AppColors.greyColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe) ...[
                // We could render avatar here, but mockup doesn't show sender avatar inside the bubble stream, just bubbles
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 0.75.sw),
                  padding: _getPadding(),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.blueColor : AppColors.grey100Color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: isMe
                          ? Radius.circular(16.r)
                          : Radius.circular(4.r),
                      bottomRight: isMe
                          ? Radius.circular(4.r)
                          : Radius.circular(16.r),
                    ),
                  ),
                  child: _buildBubbleContent(isMe),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: TextProperty(
              text: _formatTime(message.time),
              textColor: AppColors.greyColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets _getPadding() {
    if (message.imagePath != null) {
      return EdgeInsets.all(4.r);
    }
    if (message.filePath != null) {
      return EdgeInsets.all(12.r);
    }
    return EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
  }

  Widget _buildBubbleContent(bool isMe) {
    // 1. Image Attachment
    if (message.imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: message.imagePath!.startsWith('http')
            ? Image.network(message.imagePath!, fit: BoxFit.cover)
            : Image.file(File(message.imagePath!), fit: BoxFit.cover),
      );
    }

    // 2. File Attachment
    if (message.filePath != null || message.fileName != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.blueColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: AppColors.whiteColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: TextProperty(
                    text: message.fileName ?? 'document.pdf',
                    textColor: AppColors.whiteColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_circle_down,
                  color: AppColors.whiteColor,
                  size: 20.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextProperty(
                text: 'Document File',
                textColor: isMe ? AppColors.whiteColor : AppColors.blackColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(width: 20.w),
              TextProperty(
                text: message.fileSize ?? '0 B',
                textColor: isMe
                    ? AppColors.whiteColor.withValues(alpha: 0.8)
                    : AppColors.greyColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ],
      );
    }

    // 3. Simple Text Message
    return TextProperty(
      text: message.text,
      textColor: isMe ? AppColors.whiteColor : AppColors.blackColor,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);
    final min = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour.$min $period';
  }

  Widget _buildSharedEventCard(UserDiscoverClubModel item) {
    return GestureDetector(
      onTap: () {
        if (item.type == 'event') {
          final eventController = Get.isRegistered<UserEventController>()
              ? Get.find<UserEventController>()
              : Get.put(UserEventController());
          final matchedEvent = eventController.eventsList.firstWhere(
            (e) =>
                e.name.toLowerCase() == item.name.toLowerCase() ||
                e.id == item.id.toString(),
            orElse: () => eventController.eventsList.first,
          );
          Get.toNamed(AppRoute.userEventDetailsView, arguments: matchedEvent);
        } else {
          Get.toNamed(AppRoute.userClubDetailsView, arguments: item);
        }
      },
      child: Container(
        width: 220.w,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Image.asset(
                item.image,
                height: 110.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextProperty(
                    text: item.name,
                    textColor: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.blueColor,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: TextProperty(
                          text: item.location,
                          textColor: AppColors.greyColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: TextProperty(
                      text: 'View ${item.type == "event" ? "Event" : "Club"}',
                      textColor: AppColors.blueColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
