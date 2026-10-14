import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_home_controller.dart';

class ClubSummaryGrid extends StatelessWidget {
  const ClubSummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClubHomeController>();

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.50,
      children: [
        Obx(
          () => ClubSummaryCard(
            svgPath: IconPath.dollarIcon,
            iconColor: AppColors.greenColor,
            iconBgColor: AppColors.greenColor.withValues(alpha: 0.2),
            changeText: controller.revenueChange.value,
            changeColor: AppColors.greenColor,
            value: controller.revenue.value,
            label: 'Revenue This Week',
          ),
        ),
        Obx(
          () => ClubSummaryCard(
            svgPath: IconPath.personIcon,
            iconColor: AppColors.purpleColor,
            iconBgColor: AppColors.purpleColor.withValues(alpha: 0.2),
            changeText: controller.followersChange.value,
            changeColor: AppColors.purpleColor,
            value: controller.followers.value,
            label: 'Total Followers',
          ),
        ),
        Obx(
          () => ClubSummaryCard(
            svgPath: IconPath.eventIcon,
            iconColor: AppColors.amberColor,
            iconBgColor: AppColors.amberColor.withValues(alpha: 0.20),
            changeText: controller.ticketsChange.value,
            changeColor: AppColors.amberColor,
            value: controller.tickets.value,
            label: 'Tickets Sold',
          ),
        ),
        Obx(
          () => ClubSummaryCard(
            svgPath: IconPath.flameIcon,
            iconColor: AppColors.insaneColor,
            iconBgColor: AppColors.insaneColor.withValues(alpha: 0.2),
            changeText: '🔥 Trending',
            changeColor: AppColors.insaneColor,
            value: controller.heatScore.value,
            label: 'Heat Score',
            isFlame: true,
          ),
        ),
      ],
    );
  }
}

class ClubSummaryCard extends StatelessWidget {
  final IconData? iconData;
  final String? svgPath;
  final Color iconColor;
  final Color iconBgColor;
  final String changeText;
  final Color changeColor;
  final String value;
  final String label;
  final bool isFlame;

  const ClubSummaryCard({
    super.key,
    this.iconData,
    this.svgPath,
    required this.iconColor,
    required this.iconBgColor,
    required this.changeText,
    required this.changeColor,
    required this.value,
    required this.label,
    this.isFlame = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor2,
        borderRadius: BorderRadius.circular(20.r),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.015),
        //     blurRadius: 8.r,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 32.h,
                width: 32.w,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: svgPath != null
                    ? SvgPicture.asset(
                        svgPath!,
                        height: 18.h,
                        width: 18.w,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(iconData, size: 20.sp, color: iconColor),
              ),
              TextProperty(
                text: changeText,
                textColor: changeColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextProperty(
                text: value,
                textColor: AppColors.blackColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 2.h),
              TextProperty(
                text: label,
                textColor: AppColors.lightGreyColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
