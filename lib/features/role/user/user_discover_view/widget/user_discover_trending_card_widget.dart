import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';

class UserDiscoverTrendingCardWidget extends StatelessWidget {
  const UserDiscoverTrendingCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        image: const DecorationImage(
          image: AssetImage(ImagePath.feedImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          gradient: LinearGradient(
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.black.withValues(alpha: 0.3),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Trending top row
            Row(
              children: [
                // Flame icon in pink
                SvgPicture.asset(
                  IconPath.flameIcon,
                  width: 16.w,
                  height: 16.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.insaneColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 6.w),
                TextProperty(
                  text: 'TRENDING THIS WEEKEND',
                  textColor: AppColors.insaneColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            SizedBox(height: 6.h),
            // Bold title
            TextProperty(
              text: 'Las Vegas is 🔥 Right Now',
              textColor: AppColors.whiteColor,
              fontFamily: 'Sora',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 4.h),
            // Footer count
            TextProperty(
              text: '8 events happening tonight · 34k active',
              textColor: AppColors.whiteColor.withValues(alpha: 0.8),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
