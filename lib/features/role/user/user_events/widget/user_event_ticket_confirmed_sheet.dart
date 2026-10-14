import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_event_controller.dart';
import '../model/user_event_model.dart';

class UserEventTicketConfirmedSheet extends StatelessWidget {
  final UserEventModel event;

  const UserEventTicketConfirmedSheet({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserEventController>();
    final orderId = 'NL${18000 + Random().nextInt(900)}';

    String ticketText = '';
    String ticketDetails = '';
    controller.selectedQuantities.forEach((tid, qty) {
      if (qty > 0) {
        final ticket = event.tickets.firstWhere((t) => t.id == tid);
        ticketText = '${qty}x ${ticket.name}';
        ticketDetails = '${qty}x ${ticket.name}';
      }
    });

    final descriptionText = 'Your $ticketText ticket for ${event.name} have been confirmed. Check your email for your digital tickets.';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 24.h),
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),

          // Success Checkmark Circle
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: AppColors.mildColor.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.mildColor,
                width: 1.5.w,
              ),
            ),
            child: Icon(
              Icons.check,
              color: AppColors.mildColor,
              size: 36.sp,
            ),
          ),
          SizedBox(height: 20.h),

          // Title
          TextProperty(
            text: 'Ticket Confirmed! 🎉',
            textColor: AppColors.blackColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
          SizedBox(height: 12.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: TextProperty(
              text: descriptionText,
              textColor: AppColors.lightGreyColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
              lineHeight: 1.5,
            ),
          ),
          SizedBox(height: 24.h),

          // Green Ticket Info Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.mildColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.mildColor.withValues(alpha: 0.2),
                width: 1.w,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextProperty(
                      text: 'Order ID',
                      textColor: AppColors.lightGreyColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    TextProperty(
                      text: '#$orderId',
                      textColor: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextProperty(
                      text: 'Tickets',
                      textColor: AppColors.lightGreyColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    TextProperty(
                      text: ticketDetails,
                      textColor: AppColors.blackColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextProperty(
                      text: 'Total Paid',
                      textColor: AppColors.lightGreyColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    TextProperty(
                      text: '\$${controller.totalPaid.value}',
                      textColor: AppColors.mildColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Action Button
          CustomButton(
            text: 'View My Tickets',
            color: AppColors.blueColor,
            borderColor: Colors.transparent,
            borderRadius: BorderRadius.circular(100.r),
            textColor: AppColors.whiteColor,
            onTap: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Your ticket barcode has been saved to your Profile.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.blueColor,
                colorText: AppColors.whiteColor,
              );
            },
          ),
        ],
      ),
    );
  }
}
