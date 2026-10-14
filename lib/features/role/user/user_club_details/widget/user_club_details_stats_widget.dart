import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_club_details/controller/user_club_details_controller.dart';

class UserClubDetailsStatsWidget extends StatelessWidget {
  final UserClubDetailsController controller;

  const UserClubDetailsStatsWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row of 4 stats cards
        Row(
          children: [
            // Followers Card
            Expanded(
              child: Obx(
                () => _buildStatCard(
                  value: controller.followersText.value,
                  label: 'Followers',
                  valueColor: AppColors.activeColor,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Capacity Card
            Expanded(
              child: _buildStatCard(
                value: '3,000',
                label: 'Capacity',
                valueColor: AppColors.blueColor,
              ),
            ),
            SizedBox(width: 8.w),
            // Events Card
            Expanded(
              child: _buildStatCard(
                value: '8',
                label: 'Events',
                valueColor: AppColors.blueColor,
              ),
            ),
            SizedBox(width: 8.w),
            // Heat Card
            Expanded(
              child: _buildStatCard(
                value: '98%',
                label: 'Heat',
                valueColor: AppColors.redColor,
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),

        // Heat Score Progress Bar Card
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.grey50Color.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                IconPath.clubHeatScoreIcon,
                width: 24.w,
                height: 24.h,
                colorFilter: ColorFilter.mode(
                  AppColors.amberColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextProperty(
                          text: 'Heat Score',
                          textColor: AppColors.greyColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        const Spacer(),
                        TextProperty(
                          text: '88%',
                          textColor: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: 0.88,
                        minHeight: 8.h,
                        backgroundColor: AppColors.grey50Color,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.amberColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.grey50Color.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          TextProperty(
            text: value,
            textColor: valueColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 4.h),
          TextProperty(
            text: label,
            textColor: AppColors.lightGreyColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}
