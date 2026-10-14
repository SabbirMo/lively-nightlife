import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import '../controller/user_event_controller.dart';
import '../widget/user_event_list_card.dart';

class UserEventListView extends GetView<UserEventController> {
  const UserEventListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserEventController());

    return Scaffold(
      body: Stack(
        children: [
          // Blue Highlighted Background
          Image.asset(
            ImagePath.bluehighlightedBackground,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row (lively, Bell notification, Profile image)
                  Row(
                    children: [
                      TextProperty(
                        text: 'Lively',
                        textColor: AppColors.secondBlackColor,
                        fontFamily: 'Sora',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      const Spacer(),
                      // Bell Notification Icon
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoute.userNotificationView);
                            },
                            child: SvgPicture.asset(
                              IconPath.notificationBellIcon,
                              width: 24.w,
                              height: 24.h,
                            ),
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 16.w,
                              height: 16.h,
                              decoration: const BoxDecoration(
                                color: AppColors.redColor,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: TextProperty(
                                text: '4',
                                textColor: AppColors.whiteColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      // Profile image
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoute.userProfileView),
                        child: Container(
                          width: 38.w,
                          height: 38.h,
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppColors.blueColor.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 18.r,
                            backgroundImage: const NetworkImage(
                              'https://i.pravatar.cc/150?img=10',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Search Bar & Filter Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: AppColors.grey50Color,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: CustomTextfield(
                            borderRadius: 100.r,
                            borderColor: AppColors.lightGreyColor.withValues(
                              alpha: 0.2,
                            ),
                            controller: controller.searchController,
                            prefixIcon: IconPath.searchIcon,
                            fillColor: AppColors.lightGreyColor2,
                            fieldText: 'Search clubs, people...',
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Filter Button
                      Container(
                        padding: EdgeInsets.all(14.sp),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyColor2,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.lightGreyColor.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: SvgPicture.asset(
                            IconPath.filterIcon,
                            width: 20.w,
                            height: 20.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.blackColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Tab Filter Chips
                  SizedBox(
                    height: 42.h,
                    child: Obx(() {
                      final tabs = ['All', 'Tonight', 'This Week', 'Weekend'];
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: tabs.asMap().entries.map((entry) {
                            final index = entry.key;
                            final tabName = entry.value;
                            final isSelected =
                                controller.selectedTab.value == index;
                            return GestureDetector(
                              onTap: () => controller.selectTab(index),
                              child: Container(
                                margin: EdgeInsets.only(right: 10.w),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.blueColor
                                      : AppColors.lightGreyColor2,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.transparent
                                        : AppColors.lightGreyColor2,
                                    width: 1.w,
                                  ),
                                ),
                                child: TextProperty(
                                  text: tabName,
                                  textColor: isSelected
                                      ? AppColors.whiteColor
                                      : AppColors.secondBlackColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 24.h),

                  // Hot Event Card
                  Obx(() {
                    final query = controller.searchQuery.value;
                    if (query.isEmpty &&
                        (controller.selectedTab.value == 0 ||
                            controller.selectedTab.value == 3)) {
                      final hotEvents = controller.eventsList
                          .where((e) => e.isHot)
                          .toList();
                      if (hotEvents.isNotEmpty) {
                        final hotEvent = hotEvents.first;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Get.toNamed(
                                '/userEventDetailsView',
                                arguments: hotEvent,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 200.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.r),
                                  image: DecorationImage(
                                    image: hotEvent.image.startsWith('http')
                                        ? NetworkImage(hotEvent.image)
                                        : (hotEvent.image.startsWith('assets/')
                                            ? AssetImage(hotEvent.image)
                                            : FileImage(File(hotEvent.image)) as ImageProvider),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24.r),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withValues(alpha: 0.8),
                                        Colors.transparent,
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(16.r),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Top-left: HOT EVENT gradient tag
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              AppColors.gradientStartColor,
                                              AppColors.gradientEndColor,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            100.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextProperty(
                                              text: '🔥 HOT EVENT',
                                              textColor: AppColors.whiteColor,
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Bottom Title and Info
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextProperty(
                                            text: hotEvent.name,
                                            textColor: AppColors.whiteColor,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .calendar_today_outlined,
                                                    size: 12.sp,
                                                    color: AppColors.whiteColor
                                                        .withValues(alpha: 0.8),
                                                  ),
                                                  SizedBox(width: 6.w),
                                                  TextProperty(
                                                    text:
                                                        '${hotEvent.date} · ${hotEvent.time}',
                                                    textColor: AppColors
                                                        .whiteColor
                                                        .withValues(alpha: 0.8),
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ],
                                              ),
                                              TextProperty(
                                                text:
                                                    'From \$${hotEvent.price}',
                                                textColor: AppColors.whiteColor,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  }),

                  // Upcoming Events Title
                  TextProperty(
                    text: 'Upcoming Events',
                    textColor: AppColors.blackColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 14.h),

                  // Events list
                  Obx(() {
                    if (controller.filteredEvents.isEmpty) {
                      return SizedBox(
                        height: 200.h,
                        child: Center(
                          child: TextProperty(
                            text: 'No events found.',
                            textColor: AppColors.greyColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 100.h),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.filteredEvents.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 14.h),
                      itemBuilder: (context, index) {
                        final event = controller.filteredEvents[index];
                        return UserEventListCard(
                          event: event,
                          onTap: () => Get.toNamed(
                            '/userEventDetailsView',
                            arguments: event,
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
