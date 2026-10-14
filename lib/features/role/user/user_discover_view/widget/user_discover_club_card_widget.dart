import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../model/user_discover_club_model.dart';

class UserDiscoverClubCardWidget extends StatelessWidget {
  final UserDiscoverClubModel club;
  final VoidCallback onTap;

  const UserDiscoverClubCardWidget({
    super.key,
    required this.club,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withValues(alpha: 0.05),
          //     blurRadius: 10.r,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child: Image.asset(
                    club.image,
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Open status badge
                Positioned(
                  left: 14.w,
                  top: 14.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: club.isOpenNow
                                ? AppColors.mildColor
                                : AppColors.redColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        TextProperty(
                          text: club.isOpenNow ? 'Open Now' : 'Closed',
                          textColor: AppColors.whiteColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Info Body
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: Title & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextProperty(
                          text: club.name,
                          textColor: AppColors.blackColor,
                          fontFamily: 'Sora',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Rating badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.hotColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 14.sp,
                              color: AppColors.hotColor,
                            ),
                            SizedBox(width: 4.w),
                            TextProperty(
                              text: club.rating.toString(),
                              textColor: AppColors.hotColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Row: Location & Price
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: AppColors.greyColor,
                      ),
                      SizedBox(width: 4.w),
                      TextProperty(
                        text: '${club.location} · ${club.priceRange}',
                        textColor: AppColors.greyColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Row: Category Chips
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: club.categories.map((category) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blueColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: TextProperty(
                          text: category,
                          textColor: AppColors.blueColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 14.h),
                  // Divider
                  Container(height: 1.h, color: AppColors.grey50Color),
                  SizedBox(height: 12.h),
                  // Footer stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Followers
                      _buildStatItem(
                        icon: Icons.people_outline,
                        label: '${club.followersCount} followers',
                      ),
                      // Events count
                      _buildStatItem(
                        icon: Icons.calendar_today_outlined,
                        label: '${club.upcomingEventsCount} upcoming events',
                      ),
                      // Capacity
                      _buildStatItem(
                        icon: Icons.meeting_room_outlined,
                        label: club.capacity,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.lightGreyColor),
        SizedBox(width: 4.w),
        TextProperty(
          text: label,
          textColor: AppColors.lightGreyColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
