import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/controller/heat_map_controller.dart';
import 'heat_club_post_card_widget.dart';

class HeatMapBottomSheetWidget extends GetView<HeatMapController> {
  const HeatMapBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: controller.draggableController,
      initialChildSize: .16,
      minChildSize: .16,
      maxChildSize: .92,

      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),

          child: Obx(
            () => ListView(
              controller: scrollController,
              padding: EdgeInsets.all(20.w),

              children: [
                Center(
                  child: Container(
                    width: 55.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// DEFAULT STATE
                if (controller.selectedZone.value == null) ...[
                  _statisticsSection(),

                  SizedBox(height: 28.h),

                  TextProperty(
                    text: 'Popular Heat Zones',
                    textColor: AppColors.secondBlackColor,
                    fontFamily: 'Sora',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),

                  SizedBox(height: 16.h),

                  ...controller.visibleZones.map((zone) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectZone(zone);
                      },

                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),

                        padding: EdgeInsets.all(12.w),

                        decoration: BoxDecoration(
                          color: AppColors.grey100Color,
                          borderRadius: BorderRadius.circular(20.r),
                        ),

                        child: Row(
                          children: [
                            /// CLUB IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14.r),
                              child: Image.asset(
                                ImagePath.feedImage,
                                width: 65.w,
                                height: 65.w,
                                fit: BoxFit.cover,
                              ),
                            ),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextProperty(
                                    text: zone.clubName,
                                    textColor: AppColors.blackColor,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),

                                  SizedBox(height: 4.h),

                                  TextProperty(
                                    text: zone.heatLevel,
                                    textColor: _zoneColor(zone.heatPercentage),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),

                                  SizedBox(height: 4.h),

                                  TextProperty(
                                    text: '${zone.distance} km away',
                                    textColor: AppColors.greyColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                TextProperty(
                                  text: '${zone.heatPercentage.toInt()}%',
                                  textColor: _zoneColor(zone.heatPercentage),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),

                                SizedBox(height: 4.h),

                                Icon(
                                  Icons.chevron_right,
                                  color: AppColors.greyColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ]
                /// SELECTED CLUB STATE
                else ...[
                  // HeatZoneSelectedWidget(zone: controller.selectedZone.value!),
                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final controller = Get.find<HeatMapController>();

                          controller.selectedZone.value = null;

                          controller.draggableController.animateTo(
                            .16,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },

                        child: Icon(Icons.arrow_back_ios, size: 18.sp),
                      ),
                      SizedBox(width: 12.w),
                      TextProperty(
                        text: 'Live Activity Feed',
                        textColor: AppColors.blackColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  ...controller.selectedZone.value!.posts.map(
                    (post) => HeatClubPostCardWidget(post: post),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statisticsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),

      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey100Color),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem('34.6k', 'Active Now', AppColors.insaneColor),

          _statItem('47', 'Hot Events', AppColors.activeColor),

          _statItem('128', 'Clubs Open', AppColors.hotColor),

          _statItem('6', 'Heat Zones', AppColors.mildColor),
        ],
      ),
    );
  }

  Widget _statItem(String value, String title, Color textColor) {
    return Column(
      children: [
        TextProperty(
          text: value,
          textColor: textColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),

        SizedBox(height: 4.h),

        TextProperty(
          text: title,
          textColor: AppColors.lightGreyColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Color _zoneColor(double heat) {
    if (heat >= 90) {
      return AppColors.insaneColor;
    }

    if (heat >= 70) {
      return AppColors.hotColor;
    }

    if (heat >= 50) {
      return AppColors.activeColor;
    }

    return AppColors.mildColor;
  }
}
