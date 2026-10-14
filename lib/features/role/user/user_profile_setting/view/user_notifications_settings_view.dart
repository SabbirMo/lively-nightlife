import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_profile_setting_controller.dart';

class UserNotificationsSettingsView extends GetView<UserProfileSettingController> {
  const UserNotificationsSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Faded Top Blue Background Highlight
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 220.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFDCE9FE).withValues(alpha: 0.6),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Back + Title)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 22.sp,
                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      TextProperty(
                        text: 'Notifications',
                        textColor: AppColors.blackColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Sora',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SOCIAL Section
                        _buildSectionHeader('SOCIAL'),
                        SizedBox(height: 8.h),
                        _buildSocialCard(),
                        SizedBox(height: 24.h),

                        // ACTIVITY Section
                        _buildSectionHeader('ACTIVITY'),
                        SizedBox(height: 8.h),
                        _buildActivityCard(),
                        SizedBox(height: 24.h),

                        // OTHER Section
                        _buildSectionHeader('OTHER'),
                        SizedBox(height: 8.h),
                        _buildOtherCard(),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: TextProperty(
        text: title,
        textColor: AppColors.lightGreyColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildSocialCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() => _buildToggleTile(
                title: 'Likes',
                subtitle: 'When someone likes your post',
                value: controller.likes.value,
                onChanged: controller.toggleLikes,
              )),
          _buildDivider(),
          Obx(() => _buildToggleTile(
                title: 'Comments',
                subtitle: 'New comments on your posts',
                value: controller.comments.value,
                onChanged: controller.toggleComments,
              )),
          _buildDivider(),
          Obx(() => _buildToggleTile(
                title: 'New Followers',
                subtitle: 'When someone follows you',
                value: controller.newFollowers.value,
                onChanged: controller.toggleNewFollowers,
              )),
          _buildDivider(),
          Obx(() => _buildToggleTile(
                title: 'Messages',
                subtitle: 'New direct messages',
                value: controller.messages.value,
                onChanged: controller.toggleMessages,
              )),
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() => _buildToggleTile(
                title: 'Events & RSVPs',
                subtitle: 'Event updates and reminders',
                value: controller.eventsAndRSVPs.value,
                onChanged: controller.toggleEventsAndRSVPs,
              )),
          _buildDivider(),
          Obx(() => _buildToggleTile(
                title: 'Heat Map Alerts',
                subtitle: 'When nearby activity spikes',
                value: controller.heatMapAlerts.value,
                onChanged: controller.toggleHeatMapAlerts,
              )),
        ],
      ),
    );
  }

  Widget _buildOtherCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() => _buildToggleTile(
                title: 'Promotions',
                subtitle: 'Club deals and sponsored events',
                value: controller.promotions.value,
                onChanged: controller.togglePromotions,
              )),
          _buildDivider(),
          Obx(() => _buildToggleTile(
                title: 'SMS Notifications',
                subtitle: 'Text message alerts',
                value: controller.smsNotifications.value,
                onChanged: controller.toggleSmsNotifications,
              )),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextProperty(
                  text: title,
                  textColor: AppColors.blackColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 4.h),
                TextProperty(
                  text: subtitle,
                  textColor: AppColors.lightGreyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.blueColor,
              activeThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFE2E8F0),
              inactiveThumbColor: Colors.white,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      thickness: 1.h,
      color: const Color(0xFFF8FAFC),
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
