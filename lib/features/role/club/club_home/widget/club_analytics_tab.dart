import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_chart_painters.dart';

class ClubAnalyticsTab extends StatelessWidget {
  const ClubAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClubHomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Follower Growth Card
        _buildCard(
          title: 'Follower Growth (6M)',
          child: Column(
            children: [
              SizedBox(
                height: 120.h,
                width: double.infinity,
                child: CustomPaint(
                  painter: FollowerGrowthLinePainter(
                    data: controller.followerGrowthData,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: controller.followerGrowthMonths.map((m) {
                    return TextProperty(
                      text: m,
                      textColor: AppColors.lightGreyColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Weekly Tickets Card
        _buildCard(
          title: 'Weekly Tickets',
          child: Column(
            children: [
              SizedBox(
                height: 120.h,
                width: double.infinity,
                child: CustomPaint(
                  painter: WeeklyTicketsBarPainter(
                    data: controller.weeklyTicketsData,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: controller.weeklyTicketsDays.map((day) {
                  return Expanded(
                    child: TextProperty(
                      text: day,
                      textColor: AppColors.lightGreyColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Audience Insights Card
        _buildCard(
          title: 'Audience Insights',
          child: Column(
            children: [
              _buildAudienceRow('Age 18-24', 0.32, '32%'),
              SizedBox(height: 12.h),
              _buildAudienceRow('Age 25-32', 0.48, '48%'),
              SizedBox(height: 12.h),
              _buildAudienceRow('Age 33-40', 0.15, '15%'),
              SizedBox(height: 12.h),
              _buildAudienceRow('Age 40+', 0.05, '5%'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor2,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextProperty(
            text: title,
            textColor: AppColors.blackColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  Widget _buildAudienceRow(String label, double percentage, String valueText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextProperty(
              text: label,
              textColor: AppColors.lightGreyColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            TextProperty(
              text: valueText,
              textColor: AppColors.lightGreyColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
        SizedBox(height: 6.h),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 8.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.grey50Color.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4.r),
              ),
              alignment: Alignment.centerLeft,
              child: Container(
                width: constraints.maxWidth * percentage,
                height: 8.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  gradient: const LinearGradient(
                    colors: [AppColors.purpleColor, AppColors.insaneColor],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
