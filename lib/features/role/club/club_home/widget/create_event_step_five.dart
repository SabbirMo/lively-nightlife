import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_create_event_controller.dart';

class CreateEventStepFive extends GetView<ClubCreateEventController> {
  const CreateEventStepFive({super.key});

  @override
  Widget build(BuildContext context) {
    final venue = controller.selectedVenue.value.isNotEmpty
        ? controller.selectedVenue.value
        : controller.customVenueController.text.trim();
    final startTime = controller.startTimeController.text.trim();
    final endTime = controller.endTimeController.text.trim();
    final timeStr = endTime.isNotEmpty ? '$startTime - $endTime' : startTime;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor2,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.grey50Color),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBannerSection(timeStr),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLocationSection(venue),
                      SizedBox(height: 12.h),
                      _buildGenresSection(),
                      SizedBox(height: 12.h),
                      _buildDescriptionSection(),
                      SizedBox(height: 12.h),
                      _buildTagsSection(),
                      SizedBox(height: 16.h),
                      const Divider(color: AppColors.grey50Color),
                      SizedBox(height: 12.h),
                      _buildTicketsSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildBannerSection(String timeStr) {
    return Obx(() {
      final bannerPath = controller.selectedBannerPath.value;
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 16.w,
            bottom: 16.h,
            right: 16.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextProperty(
                  text: controller.titleController.text.trim().isEmpty
                      ? 'Untitled Event'
                      : controller.titleController.text.trim(),
                  textColor: AppColors.whiteColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 4.h),
                TextProperty(
                  text: '${controller.dateController.text.trim()} · $timeStr',
                  textColor: AppColors.whiteColor.withValues(alpha: 0.8),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLocationSection(String venue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          color: AppColors.insaneColor,
          size: 20.w,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: TextProperty(
            text: venue.isEmpty ? 'No Location Selected' : venue,
            textColor: AppColors.greyColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildGenresSection() {
    return Obx(() {
      if (controller.selectedGenres.isEmpty) return const SizedBox.shrink();
      return Wrap(
        spacing: 8.w,
        runSpacing: 4.h,
        children: controller.selectedGenres.map((g) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.purpleColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: TextProperty(
              text: g,
              textColor: AppColors.purpleColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildDescriptionSection() {
    final desc = controller.descriptionController.text.trim();
    if (desc.isEmpty) return const SizedBox.shrink();
    return TextProperty(
      text: desc,
      textColor: AppColors.blackColor.withValues(alpha: 0.8),
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      maxLines: 5,
    );
  }

  Widget _buildTagsSection() {
    return Obx(() {
      if (controller.eventTags.isEmpty) return const SizedBox.shrink();
      return Wrap(
        spacing: 8.w,
        runSpacing: 4.h,
        children: controller.eventTags.map((tag) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: TextProperty(
              text: tag,
              textColor: AppColors.primaryColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildTicketsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextProperty(
          text: 'Tickets',
          textColor: AppColors.blackColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 8.h),
        Obx(() {
          if (controller.ticketTiers.isEmpty) {
            return TextProperty(
              text: 'No Ticket Tiers Created',
              textColor: AppColors.greyColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.ticketTiers.length,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, idx) {
              final tier = controller.ticketTiers[idx];
              final name = tier.nameController.text.trim().isEmpty
                  ? 'General Admission'
                  : tier.nameController.text.trim();
              final price = tier.priceController.text.trim().isEmpty
                  ? '0'
                  : tier.priceController.text.trim();
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextProperty(
                    text: name,
                    textColor: AppColors.greyColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  TextProperty(
                    text: '\$$price',
                    textColor: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              );
            },
          );
        }),
      ],
    );
  }
}
