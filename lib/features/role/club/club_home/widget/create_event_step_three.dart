import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_create_event_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/model/create_event_models.dart';

class CreateEventStepThree extends GetView<ClubCreateEventController> {
  const CreateEventStepThree({super.key});

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
                  text: 'Create ticket tiers for your event. All prices in USD.',
                  textColor: AppColors.greyColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 16.h),
                Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.ticketTiers.length,
                  itemBuilder: (context, idx) {
                    final tier = controller.ticketTiers[idx];
                    return _buildTicketTierCard(tier, idx);
                  },
                )),
                SizedBox(height: 12.h),
                _buildAddTierButton(),
                SizedBox(height: 20.h),
                _buildCommissionAlert(),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketTierCard(EventTicketTier tier, int index) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextProperty(
                text: 'Ticket Tier ${index + 1}',
                textColor: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
              if (controller.ticketTiers.length > 1)
                GestureDetector(
                  onTap: () => controller.removeTicketTier(index),
                  child: Icon(
                    Icons.close,
                    color: AppColors.redColor.withValues(alpha: 0.7),
                    size: 20.w,
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomTextfield(
            controller: tier.nameController,
            fieldText: 'Tier Name (e.g. General Admission)',
            fillColor: AppColors.whiteColor,
            borderRadius: 12.r,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomTextfield(
                  controller: tier.priceController,
                  fieldText: 'Price',
                  keyboardType: TextInputType.number,
                  fillColor: AppColors.whiteColor,
                  borderRadius: 12.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextfield(
                  controller: tier.qtyController,
                  fieldText: 'Qty',
                  keyboardType: TextInputType.number,
                  fillColor: AppColors.whiteColor,
                  borderRadius: 12.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomTextfield(
            controller: tier.descController,
            fieldText: 'Description (optional — e.g. Includes open bar)',
            fillColor: AppColors.whiteColor,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }

  Widget _buildAddTierButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: controller.addTicketTier,
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
          text: 'Add Another Tier',
          textColor: AppColors.primaryColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCommissionAlert() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.amberColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.amberColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.amberColor, size: 20.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextProperty(
                  text: 'Platform Commission',
                  textColor: AppColors.amberColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 4.h),
                TextProperty(
                  text: 'NIGHTLIFE charges a 3% platform fee per ticket sold. You keep 97%.',
                  textColor: AppColors.greyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
