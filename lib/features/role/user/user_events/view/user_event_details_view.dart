import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_home_view/widget/home_header_widget.dart';
import '../controller/user_event_controller.dart';
import '../model/user_event_model.dart';
import '../widget/user_event_artist_capsule.dart';
import '../widget/user_event_hosted_by_box.dart';
import '../widget/user_event_info_card.dart';
import '../widget/user_event_info_row.dart';
import '../widget/user_event_share_bottom_sheet.dart';
import '../widget/user_event_tickets_card_box.dart';

class UserEventDetailsView extends StatelessWidget {
  const UserEventDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserEventController>();
    final UserEventModel event = Get.arguments ?? controller.eventsList.first;
    final RxBool isFollowingClub = false.obs;

    final Widget imageWidget;
    final fallback = Container(
      width: double.infinity,
      height: 280.h,
      color: AppColors.grey50Color,
      child: const Icon(
        Icons.broken_image,
        size: 50,
        color: AppColors.greyColor,
      ),
    );

    if (event.image.startsWith('http')) {
      imageWidget = Image.network(
        event.image,
        width: double.infinity,
        height: 280.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    } else if (event.image.startsWith('assets/')) {
      imageWidget = Image.asset(
        event.image,
        width: double.infinity,
        height: 280.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    } else if (event.image.isNotEmpty) {
      imageWidget = Image.file(
        File(event.image),
        width: double.infinity,
        height: 280.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    } else {
      imageWidget = fallback;
    }

    return Scaffold(
      backgroundColor: AppColors.lightGreyColor2,
      body: Stack(
        children: [
          // Scrollable Body
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 50.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover Image with Gradient & Hashtag overlay
                Stack(
                  children: [
                    imageWidget,
                    Container(
                      height: 280.h,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.whiteColor, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    // Hashtag Overlay
                    Positioned(
                      bottom: 16.h,
                      left: 16.w,
                      right: 16.w,
                      child: Builder(
                        builder: (context) {
                          final tagsList = event.tags.isNotEmpty
                              ? event.tags
                              : event.categories;
                          return Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: tagsList.map((tag) {
                              final text = tag.startsWith('#') ? tag : '#$tag';
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                                child: TextProperty(
                                  text: text,
                                  textColor: AppColors.whiteColor,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Main Info Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Name
                      TextProperty(
                        text: event.name,
                        textColor: AppColors.blackColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 16.h),

                      // Info Rows
                      UserEventInfoRow(
                        icon: IconPath.eventIcon,
                        iconColor: AppColors.purpleColor,
                        text: '${event.date} · ${event.time} - 4:00 AM',
                      ),
                      SizedBox(height: 10.h),
                      UserEventInfoRow(
                        icon: IconPath.eventLocationIcon,
                        iconColor: AppColors.gradientStartColor,
                        text: event.location,
                      ),
                      SizedBox(height: 10.h),
                      UserEventInfoRow(
                        icon: IconPath.personIcon,
                        text:
                            '${event.goingCount} going · ${event.interestedCount} interested',
                      ),
                      SizedBox(height: 20.h),

                      // Going! & Share Row
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              final isRsvped = event.isRsvped.value;
                              return CustomButton(
                                text: isRsvped ? 'Going!' : '✓ RSVP Free',
                                color: isRsvped
                                    ? AppColors.mildColor.withValues(
                                        alpha: 0.12,
                                      )
                                    : AppColors.blueColor,
                                borderColor: isRsvped
                                    ? AppColors.mildColor
                                    : Colors.transparent,
                                textColor: isRsvped
                                    ? AppColors.mildColor
                                    : AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(100.r),
                                icon: isRsvped
                                    ? Icons.check_circle_outline
                                    : null,
                                iconColor: isRsvped
                                    ? AppColors.mildColor
                                    : null,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                onTap: () => controller.toggleRsvp(event),
                              );
                            }),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    UserEventShareBottomSheet(event: event),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.grey50Color,
                                  width: 1.w,
                                ),
                              ),
                              child: SvgPicture.asset(
                                IconPath.shareIcon,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.greyColor,
                                  BlendMode.srcIn,
                                ),
                                width: 20.w,
                                height: 20.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Tickets Box Card (Custom Widget)
                      UserEventTicketsCardBox(
                        event: event,
                        controller: controller,
                      ),
                      SizedBox(height: 24.h),

                      // Lineup List
                      TextProperty(
                        text: 'Lineup',
                        textColor: AppColors.blackColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 12.h),
                      Column(
                        children: event.lineup
                            .map(
                              (artist) =>
                                  UserEventArtistCapsule(artist: artist),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 24.h),

                      // About Section
                      TextProperty(
                        text: 'About',
                        textColor: AppColors.blackColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 8.h),
                      TextProperty(
                        text: event.description,
                        textColor: AppColors.lightGreyColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        lineHeight: 1.5,
                      ),
                      SizedBox(height: 16.h),

                      // Dress Code / Age Restriction cards side by side
                      Row(
                        children: [
                          Expanded(
                            child: UserEventInfoCard(
                              title: 'Dress Code',
                              value: event.dressCode.isNotEmpty
                                  ? event.dressCode
                                  : 'Upscale Nightclub',
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: UserEventInfoCard(
                              title: 'Age Restriction',
                              value: event.ageRestriction.isNotEmpty
                                  ? event.ageRestriction
                                  : '21+',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Hosted By Box (Custom Widget)
                      UserEventHostedByBox(
                        event: event,
                        isFollowing: isFollowingClub,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Header Overlay
          Positioned(
            top: 40.h,
            left: 16.w,
            right: 16.w,
            child: const HomeHeaderWidget(
              showBackButton: true,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
