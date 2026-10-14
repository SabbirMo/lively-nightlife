import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/model/club_event_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/view/club_create_event_view.dart';

class ClubEventCard extends StatelessWidget {
  final ClubEventModel event;
  const ClubEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget;
    if (event.imagePath.startsWith('http')) {
      imageWidget = Image.network(event.imagePath, width: double.infinity, height: 160.h, fit: BoxFit.cover);
    } else if (event.imagePath.startsWith('assets/')) {
      imageWidget = Image.asset(event.imagePath, width: double.infinity, height: 160.h, fit: BoxFit.cover);
    } else {
      imageWidget = Image.file(File(event.imagePath), width: double.infinity, height: 160.h, fit: BoxFit.cover);
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey50Color.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                child: imageWidget,
              ),
              if (event.isOpen)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F5A3E).withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(height: 6.h, width: 6.w, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                        SizedBox(width: 6.w),
                        Text('Open Now', style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextProperty(text: event.title, textColor: AppColors.blackColor, fontSize: 20.sp, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(12.r)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 14.sp, color: const Color(0xFFD97706)),
                          SizedBox(width: 4.w),
                          Text(event.rating.toString(), style: TextStyle(color: const Color(0xFFD97706), fontSize: 12.sp, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SvgPicture.asset(IconPath.locationIcon, height: 14.h, width: 14.w, colorFilter: const ColorFilter.mode(AppColors.lightGreyColor, BlendMode.srcIn)),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: TextProperty(text: '${event.location} · ${event.priceTier}', textColor: AppColors.lightGreyColor, fontSize: 13.sp, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: _buildStatBox(event.rsvps, 'RSVPs', AppColors.purpleColor)),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildStatBox(event.ticketsSold, 'Tickets Sold', const Color(0xFF00C950))),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildStatBox(event.revenue, 'Revenue', const Color(0xFFFE9A00))),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: _buildButton('Edit', AppColors.primaryColor, Colors.white, () {
                      Get.to(() => const ClubCreateEventView(), arguments: event);
                    })),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildButton('Analytics', AppColors.grey50Color.withValues(alpha: 0.5), AppColors.secondBlackColor, () {})),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  text: 'Cancel Event',
                  color: AppColors.lightGreyColor2,
                  textColor: AppColors.redColor,
                  borderColor: AppColors.grey50Color.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(24.r),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.grey50Color.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(color: color, fontSize: 16.sp, fontWeight: FontWeight.w700)),
          SizedBox(height: 4.h),
          Text(label, style: TextStyle(color: AppColors.lightGreyColor, fontSize: 11.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildButton(String label, Color bg, Color textCol, VoidCallback onPressed) {
    return CustomButton(
      text: label,
      color: bg,
      textColor: textCol,
      borderRadius: BorderRadius.circular(24.r),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      onTap: onPressed,
    );
  }
}
