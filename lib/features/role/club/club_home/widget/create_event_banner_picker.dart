import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_create_event_controller.dart';

class CreateEventBannerPicker extends GetView<ClubCreateEventController> {
  const CreateEventBannerPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextProperty(
          text: 'Event Banner',
          textColor: AppColors.lightGreyColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 8.h),
        Obx(() {
          final bannerPath = controller.selectedBannerPath.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: bannerPath.startsWith('assets/')
                    ? Image.asset(
                        bannerPath,
                        width: double.infinity,
                        height: 180.h,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(bannerPath),
                        width: double.infinity,
                        height: 180.h,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                child: GestureDetector(
                  onTap: controller.pickBannerFromGallery,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: AppColors.whiteColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        TextProperty(
                          text: 'Upload',
                          textColor: AppColors.whiteColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
        // SizedBox(height: 12.h),
        // SizedBox(
        //   height: 48.h,
        //   child: ListView.separated(
        //     scrollDirection: Axis.horizontal,
        //     itemCount: controller.presetBanners.length,
        //     separatorBuilder: (context, index) => SizedBox(width: 8.w),
        //     itemBuilder: (context, index) {
        //       final path = controller.presetBanners[index];
        //       return GestureDetector(
        //         onTap: () => controller.selectPresetBanner(path),
        //         child: Obx(() {
        //           final isSelected = controller.selectedBannerPath.value == path;
        //           return Container(
        //             width: 72.w,
        //             height: 48.h,
        //             decoration: BoxDecoration(
        //               border: Border.all(
        //                 color: isSelected ? AppColors.primaryColor : Colors.transparent,
        //                 width: 2.w,
        //               ),
        //               borderRadius: BorderRadius.circular(10.r),
        //             ),
        //             child: ClipRRect(
        //               borderRadius: BorderRadius.circular(8.r),
        //               child: Image.asset(path, fit: BoxFit.cover),
        //             ),
        //           );
        //         }),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
