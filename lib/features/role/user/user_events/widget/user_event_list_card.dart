import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../model/user_event_model.dart';

class UserEventListCard extends StatelessWidget {
  final UserEventModel event;
  final VoidCallback onTap;

  const UserEventListCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget;
    final fallback = Container(
      width: 80.w,
      height: 100.h,
      color: AppColors.grey50Color,
      child: const Icon(Icons.broken_image, color: AppColors.greyColor),
    );

    if (event.image.startsWith('http')) {
      imageWidget = Image.network(
        event.image,
        width: 80.w,
        height: 100.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    } else if (event.image.startsWith('assets/')) {
      imageWidget = Image.asset(
        event.image,
        width: 80.w,
        height: 100.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    } else {
      imageWidget = Image.file(
        File(event.image),
        width: 80.w,
        height: 100.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Event Image (vertical layout, rounded corners)
            ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: imageWidget,
            ),
            SizedBox(width: 14.w),
            
            // Right: Details Column
            Expanded(
              child: SizedBox(
                height: 100.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    TextProperty(
                      text: event.name,
                      textColor: AppColors.secondBlackColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Metadata: Date & Location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12.sp,
                              color: AppColors.lightGreyColor,
                            ),
                            SizedBox(width: 6.w),
                            TextProperty(
                              text: event.date,
                              textColor: AppColors.lightGreyColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        
                        // Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12.sp,
                              color: AppColors.lightGreyColor,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: TextProperty(
                                text: event.location.split(',').first, // Only show main club name
                                textColor: AppColors.lightGreyColor,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    // Bottom Row: Category Chips & Price Tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category Chips
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: event.categories.take(2).map((cat) {
                                return Container(
                                  margin: EdgeInsets.only(right: 6.w),
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.purpleColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: TextProperty(
                                    text: cat,
                                    textColor: AppColors.purpleColor,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        
                        // Price
                        TextProperty(
                          text: '\$${event.price}',
                          textColor: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
