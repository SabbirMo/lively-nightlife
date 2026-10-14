import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_create_event_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/model/create_event_models.dart';

class CreateEventStepFour extends GetView<ClubCreateEventController> {
  const CreateEventStepFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextProperty(
                  text: 'Add artists, DJs, or performers to your lineup (optional)',
                  textColor: AppColors.greyColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 16.h),
                Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.lineup.length,
                  itemBuilder: (context, idx) {
                    final artist = controller.lineup[idx];
                    return _buildArtistCard(artist, idx);
                  },
                )),
                SizedBox(height: 12.h),
                _buildAddArtistButton(),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArtistCard(EventArtist artist, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor2,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey50Color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: NetworkImage(artist.avatar),
              ),
              SizedBox(width: 12.w),
              TextProperty(
                text: 'Artist ${index + 1}',
                textColor: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.removeArtist(index),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.redColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.redColor,
                    size: 16.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomTextfield(
            controller: artist.nameController,
            fieldText: 'Artist / DJ name',
            fillColor: AppColors.whiteColor,
            borderRadius: 12.r,
          ),
          SizedBox(height: 12.h),
          Obx(() {
            final currentRole = artist.role.value;
            return Wrap(
              spacing: 8.w,
              children: ['Headliner', 'Co-Headliner', 'Support'].map((role) {
                final isSelected = currentRole == role;
                return GestureDetector(
                  onTap: () => artist.role.value = role,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.08)
                          : AppColors.grey50Color.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryColor : Colors.transparent,
                        width: 1.w,
                      ),
                    ),
                    child: TextProperty(
                      text: role,
                      textColor: isSelected ? AppColors.primaryColor : AppColors.greyColor,
                      fontSize: 12.sp,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAddArtistButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: controller.addArtist,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.05),
        ),
        icon: Icon(Icons.add, color: AppColors.primaryColor, size: 20.w),
        label: TextProperty(
          text: 'Add Artist',
          textColor: AppColors.primaryColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
