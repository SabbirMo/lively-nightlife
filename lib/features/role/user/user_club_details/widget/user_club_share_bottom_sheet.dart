import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_club_details_controller.dart';

class UserClubShareBottomSheet extends StatelessWidget {
  final UserClubDetailsController controller;

  const UserClubShareBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final users = [
      {'name': 'Alex', 'color': const Color(0xFFC084FC)}, // Purple
      {'name': 'Emma', 'color': const Color(0xFFF472B6)}, // Pink
      {'name': 'Ryan', 'color': const Color(0xFF60A5FA)}, // Blue
      {'name': 'Sophia', 'color': const Color(0xFF34D399)}, // Green
      {'name': 'John', 'color': const Color(0xFFFBBF24)}, // Amber
      {'name': 'Oliver', 'color': const Color(0xFFF87171)}, // Red
      {'name': 'Mia', 'color': const Color(0xFF2DD4BF)}, // Teal
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
            text: 'Share Club',
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
                  onTap: () {
                    Get.back();
                    controller.shareExternally();
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
                  onTap: () {
                    Get.back();
                    Get.snackbar(
                      'Copied',
                      'Link copied successfully',
                      backgroundColor: AppColors.blueColor,
                      colorText: AppColors.whiteColor,
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

          // Horizontal Contacts List
          SizedBox(
            height: 90.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final String name = user['name'] as String;
                final Color avatarColor = user['color'] as Color;

                return GestureDetector(
                  onTap: () => controller.shareInApp(name),
                  child: Padding(
                    padding: EdgeInsets.only(right: 18.w),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 26.r,
                          backgroundColor: avatarColor.withValues(alpha: 0.15),
                          child: TextProperty(
                            text: name[0],
                            textColor: avatarColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        TextProperty(
                          text: name,
                          textColor: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
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
