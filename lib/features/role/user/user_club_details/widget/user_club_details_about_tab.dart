import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';

class UserClubDetailsAboutTab extends StatelessWidget {
  const UserClubDetailsAboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      'VIP Tables',
      'Multiple Bars',
      'Dance Floor',
      'Outdoor Terrace',
      'VIP Lounge'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description Paragraph
        TextProperty(
          text:
              "Las Vegas's most iconic nightclub experience. World-class DJs, jaw-dropping chandelier, and the ultimate party atmosphere on the Strip.",
          textColor: AppColors.greyColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          lineHeight: 1.5,
        ),

        SizedBox(height: 20.h),

        // Business Info details with icons
        _buildInfoRow(
          iconPath: IconPath.eventTimeIcon,
          text: 'Thu-Sun 10:30PM-5AM',
        ),
        SizedBox(height: 14.h),
        _buildInfoRow(
          iconPath: IconPath.eventLocationIcon,
          text: '3570 Las Vegas Blvd S',
        ),
        SizedBox(height: 14.h),
        _buildInfoRow(
          iconPath: IconPath.clubContactNumIcon,
          text: '+1 (702) 785-9999',
        ),
        SizedBox(height: 14.h),
        _buildInfoRow(
          iconPath: IconPath.clubWebsiteIcon,
          text: 'omnianightclub.com',
        ),

        SizedBox(height: 24.h),

        // Feature chips
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: features.map((feature) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.grey50Color.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TextProperty(
                text: feature,
                textColor: AppColors.grey700Color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String iconPath,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconPath,
          width: 20.w,
          height: 20.h,
          colorFilter: const ColorFilter.mode(
            AppColors.activeColor,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: TextProperty(
            text: text,
            textColor: AppColors.grey700Color,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
