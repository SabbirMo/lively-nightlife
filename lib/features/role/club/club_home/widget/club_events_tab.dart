import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_home_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/club_event_card.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/view/club_create_event_view.dart';

class ClubEventsTab extends StatelessWidget {
  const ClubEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClubHomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Create New Event Button
        CustomButton(
          iconImagePath: IconPath.addIcon,
          height: 14.h,
          text: 'Create New Event',
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100.r),
          onTap: () => Get.to(() => const ClubCreateEventView()),
        ),
        SizedBox(height: 24.h),
        // Section Header
        TextProperty(
          text: 'Upcoming Events',
          textColor: AppColors.blackColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 16.h),
        // List of Event Cards
        Obx(() {
          if (controller.upcomingEvents.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: TextProperty(
                  text: 'No upcoming events',
                  textColor: AppColors.lightGreyColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.upcomingEvents.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final event = controller.upcomingEvents[index];
              return ClubEventCard(event: event);
            },
          );
        }),
      ],
    );
  }
}
