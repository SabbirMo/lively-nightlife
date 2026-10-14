import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_event_controller.dart';
import '../model/user_event_model.dart';
import 'user_event_ticket_confirmed_sheet.dart';

class UserEventGetTicketsSheet extends StatelessWidget {
  final UserEventModel event;

  const UserEventGetTicketsSheet({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserEventController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: AppColors.lightGreyColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),

          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextProperty(
                text: 'Get Tickets',
                textColor: AppColors.blackColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: const BoxDecoration(
                    color: AppColors.grey50Color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.blackColor,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Event Name & Date
          TextProperty(
            text: event.name,
            textColor: AppColors.blackColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 4.h),
          TextProperty(
            text: '${event.date} · ${event.time}',
            textColor: AppColors.lightGreyColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 20.h),

          // Tickets List
          Flexible(
            child: Obx(() {
              final selectedId = controller.selectedTicketId.value;
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: event.tickets.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final ticket = event.tickets[index];
                  final isSelected = selectedId == ticket.id;
                  final qty = controller.selectedQuantities[ticket.id] ?? 0;

                  return GestureDetector(
                    onTap: () => controller.selectTicket(event, ticket.id),
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.blueColor.withValues(alpha: 0.08)
                            : AppColors.lightGreyColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.blueColor.withValues(alpha: 0.2)
                              : AppColors.lightGreyColor.withValues(
                                  alpha: 0.15,
                                ),
                          width: 1.w,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextProperty(
                                text: ticket.name,
                                textColor: AppColors.blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              TextProperty(
                                text: '\$${ticket.price}',
                                textColor: AppColors.blackColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          TextProperty(
                            text: '${ticket.available} remaining',
                            textColor: AppColors.lightGreyColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          if (isSelected) ...[
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                TextProperty(
                                  text: 'Quantity:',
                                  textColor: AppColors.lightGreyColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => controller.adjustQuantity(
                                    event,
                                    ticket.id,
                                    -1,
                                  ),
                                  child: Container(
                                    width: 28.w,
                                    height: 28.w,
                                    decoration: const BoxDecoration(
                                      color: AppColors.blueColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                TextProperty(
                                  text: '$qty',
                                  textColor: AppColors.blackColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(width: 16.w),
                                GestureDetector(
                                  onTap: () => controller.adjustQuantity(
                                    event,
                                    ticket.id,
                                    1,
                                  ),
                                  child: Container(
                                    width: 28.w,
                                    height: 28.w,
                                    decoration: const BoxDecoration(
                                      color: AppColors.blueColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          SizedBox(height: 24.h),

          // Total and Purchase Button
          Obx(() {
            final total = controller.totalPaid.value;
            final count = controller.getSelectedQuantityCount();
            final hasTickets = count > 0;
            final buttonText = count == 1
                ? 'Purchase 1 Ticket'
                : 'Purchase $count Tickets';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextProperty(
                      text: 'Total',
                      textColor: AppColors.lightGreyColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    TextProperty(
                      text: '\$$total',
                      textColor: AppColors.blackColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                CustomButton(
                  text: buttonText,
                  color: hasTickets
                      ? AppColors.blueColor
                      : AppColors.greyColor.withValues(alpha: 0.5),
                  borderColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(100.r),
                  textColor: AppColors.whiteColor,
                  icon: Icons.confirmation_number_outlined,
                  iconColor: AppColors.whiteColor,
                  onTap: () {
                    if (!hasTickets) {
                      Get.snackbar(
                        'Select Tickets',
                        'Please select at least 1 ticket to purchase.',
                        backgroundColor: AppColors.redColor,
                        colorText: AppColors.whiteColor,
                      );
                      return;
                    }
                    Get.back();
                    showModalBottomSheet(
                      context: Get.context!,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          UserEventTicketConfirmedSheet(event: event),
                    );
                  },
                ),
                SizedBox(height: 12.h),
                Center(
                  child: TextProperty(
                    text: 'Secure checkout powered by Stripe · No fees',
                    textColor: AppColors.lightGreyColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
