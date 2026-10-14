import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/controller/heat_map_controller.dart';


class HeatMapFilterBottomSheet extends GetView<HeatMapController> {
  const HeatMapFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),

      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.r),
        ),
      ),

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Center(
              child: Container(
                width: 60.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                      BorderRadius.circular(
                    100.r,
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            TextProperty(
              text: 'Filters',
              textColor:
                  AppColors.blackColor,
              fontSize: 22.sp,
              fontWeight:
                  FontWeight.w700,
            ),

            SizedBox(height: 24.h),

            /// VIEW TYPE

            TextProperty(
              text: 'Show',
              textColor:
                  AppColors.blackColor,
              fontSize: 16.sp,
              fontWeight:
                  FontWeight.w600,
            ),

            SizedBox(height: 12.h),

            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [

                _chip(
                  title: 'Clubs',
                  selected:
                      controller.showClubs.value,
                  onTap: () {
                    controller.showClubs.toggle();
                  },
                ),

                _chip(
                  title: 'Areas',
                  selected:
                      controller.showAreas.value,
                  onTap: () {
                    controller.showAreas.toggle();
                  },
                ),
              ],
            ),

            SizedBox(height: 24.h),

            /// DISTANCE

            TextProperty(
              text: 'Distance',
              textColor:
                  AppColors.blackColor,
              fontSize: 16.sp,
              fontWeight:
                  FontWeight.w600,
            ),

            SizedBox(height: 12.h),

            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [

                _distanceChip(1),
                _distanceChip(5),
                _distanceChip(10),
                _distanceChip(25),
              ],
            ),

            SizedBox(height: 24.h),

            /// HEAT LEVEL

            TextProperty(
              text: 'Heat Level',
              textColor:
                  AppColors.blackColor,
              fontSize: 16.sp,
              fontWeight:
                  FontWeight.w600,
            ),

            SizedBox(height: 12.h),

            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: [

                _heatChip('Insane'),
                _heatChip('Hot'),
                _heatChip('Active'),
                _heatChip('Mild'),
              ],
            ),

            SizedBox(height: 30.h),

            CustomButton(
              text: 'Apply Filters',
              borderRadius:
                  BorderRadius.circular(
                100.r,
              ),
              onTap: () {
                Get.back();
              },
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _chip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
          vertical: 10.h,
        ),

        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor
              : AppColors.grey100Color,

          borderRadius:
              BorderRadius.circular(
            100.r,
          ),
        ),

        child: TextProperty(
          text: title,
          textColor: selected
              ? AppColors.whiteColor
              : AppColors.blackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _distanceChip(
    int km,
  ) {
    return Obx(() {
      final selected =
          controller.selectedDistance.value ==
              km;

      return _chip(
        title: '$km km',
        selected: selected,
        onTap: () {
          controller.selectedDistance.value =
              km;
        },
      );
    });
  }

  Widget _heatChip(
    String heat,
  ) {
    return Obx(() {
      final selected =
          controller.selectedHeat.value ==
              heat;

      return _chip(
        title: heat,
        selected: selected,
        onTap: () {
          controller.selectedHeat.value =
              heat;
        },
      );
    });
  }
}