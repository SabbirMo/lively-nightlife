import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_events/controller/user_event_controller.dart';

class UserClubDetailsEventsTab extends StatelessWidget {
  const UserClubDetailsEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      _EventData(
        title: 'ULTRA x Omnia: Martin Garrix Live',
        date: '2026-06-14',
        location: 'Omnia Nightclub',
        categories: ['EDM', 'Synthwave'],
        price: r'$75',
        image: ImagePath.feedImage,
      ),
      _EventData(
        title: 'Coachella Valley Music and Arts Festival',
        date: '2026-04-10',
        location: 'Empire Polo Club',
        categories: ['Alternative Rock', 'Indie Pop'],
        price: r'$350',
        image: ImagePath.feedImage,
      ),
    ];

    return Column(
      children: events.map((event) => _buildEventCard(event)).toList(),
    );
  }

  Widget _buildEventCard(_EventData event) {
    return GestureDetector(
      onTap: () {
        final eventController = Get.isRegistered<UserEventController>()
            ? Get.find<UserEventController>()
            : Get.put(UserEventController());
        final matchedEvent = eventController.eventsList.firstWhere(
          (e) =>
              e.name.toLowerCase().contains(event.title.toLowerCase()) ||
              event.title.toLowerCase().contains(e.name.toLowerCase()),
          orElse: () => eventController.eventsList.first,
        );
        Get.toNamed('/userEventDetailsView', arguments: matchedEvent);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.grey50Color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                event.image,
                width: 80.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),

            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextProperty(
                    text: event.title,
                    textColor: AppColors.blackColor,
                    fontFamily: 'Sora',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),

                  // Date row
                  Row(
                    children: [
                      SvgPicture.asset(IconPath.calendarIcon),
                      SizedBox(width: 6.w),
                      TextProperty(
                        text: event.date,
                        textColor: AppColors.lightGreyColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Location row
                  Row(
                    children: [
                      SvgPicture.asset(
                        IconPath.eventLocationIcon,
                        colorFilter: const ColorFilter.mode(
                          AppColors.lightGreyColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      TextProperty(
                        text: event.location,
                        textColor: AppColors.lightGreyColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Tags & Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 6.w,
                          children: event.categories.map((cat) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.purpleColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: TextProperty(
                                text: cat,
                                textColor: AppColors.purpleColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      TextProperty(
                        text: event.price,
                        textColor: AppColors.blackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
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
}

class _EventData {
  final String title;
  final String date;
  final String location;
  final List<String> categories;
  final String price;
  final String image;

  _EventData({
    required this.title,
    required this.date,
    required this.location,
    required this.categories,
    required this.price,
    required this.image,
  });
}
