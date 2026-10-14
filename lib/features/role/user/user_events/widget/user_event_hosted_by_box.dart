import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/controller/user_discover_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/user_discover_view/model/user_discover_club_model.dart';
import '../model/user_event_model.dart';

class UserEventHostedByBox extends StatelessWidget {
  final UserEventModel event;
  final RxBool isFollowing;

  const UserEventHostedByBox({
    super.key,
    required this.event,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamically match the club based on the event's location name
    UserDiscoverClubModel? matchedClub;
    final clubName = event.location.split(',').first.trim().toLowerCase();

    if (Get.isRegistered<UserDiscoverController>()) {
      final discoverController = Get.find<UserDiscoverController>();
      matchedClub = discoverController.clubsList.firstWhereOrNull(
        (c) =>
            c.name.toLowerCase().contains(clubName) ||
            clubName.contains(c.name.toLowerCase()),
      );
    }

    // Dynamic fallback or safe defaults using matched fields
    final String logo = matchedClub?.image ?? ImagePath.clubCoverPhoto;
    final String name =
        matchedClub?.name ?? event.location.split(',').first.trim();
    final String followers = matchedClub?.followersCount ?? '150k';

    // Model argument to pass to details screen
    final clubArg =
        matchedClub ??
        UserDiscoverClubModel(
          id: 1,
          name: name,
          rating: 4.8,
          location: event.location,
          priceRange: r'$$$',
          categories: const ['Club'],
          followersCount: followers,
          upcomingEventsCount: 1,
          capacity: 'N/A',
          isOpenNow: true,
          image: logo,
          type: 'club',
        );

    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 24.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey50Color, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextProperty(
            text: 'Hosted by',
            textColor: AppColors.lightGreyColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () =>
                Get.toNamed(AppRoute.userClubDetailsView, arguments: clubArg),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: logo.startsWith('http')
                      ? Image.network(
                          logo,
                          width: 44.w,
                          height: 44.h,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          logo,
                          width: 44.w,
                          height: 44.h,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextProperty(
                        text: name,
                        textColor: AppColors.secondBlackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 2.h),
                      TextProperty(
                        text: '$followers followers',
                        textColor: AppColors.lightGreyColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  final isFollow = isFollowing.value;
                  return CustomButton(
                    text: isFollow ? 'Following' : 'Follow',
                    color: isFollow
                        ? AppColors.grey50Color
                        : AppColors.blueColor,
                    borderColor: isFollow
                        ? AppColors.grey50Color
                        : Colors.transparent,
                    textColor: isFollow
                        ? AppColors.greyColor
                        : AppColors.whiteColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    borderRadius: BorderRadius.circular(100.r),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    onTap: () => isFollowing.toggle(),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
