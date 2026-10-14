import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import '../controller/user_event_controller.dart';
import '../model/user_event_model.dart';
import 'user_event_get_tickets_sheet.dart';

class UserEventTicketsCardBox extends StatelessWidget {
  final UserEventModel event;
  final UserEventController controller;

  const UserEventTicketsCardBox({
    super.key,
    required this.event,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextProperty(
                text: 'Tickets',
                textColor: AppColors.secondBlackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              TextProperty(
                text: '21+',
                textColor: AppColors.lightGreyColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...event.tickets.map((ticket) {
            final double percent = ticket.total > 0
                ? (ticket.available / ticket.total)
                : 0.0;
            return Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextProperty(
                        text: ticket.name,
                        textColor: AppColors.secondBlackColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 4.h),
                      TextProperty(
                        text: '${ticket.available}/${ticket.total} available',
                        textColor: AppColors.lightGreyColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextProperty(
                        text: '\$${ticket.price}',
                        textColor: AppColors.blackColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(
                        width: 50.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 3.h,
                            backgroundColor: AppColors.grey50Color,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 10.h),
          CustomButton(
            text: 'Buy Tickets',
            borderRadius: BorderRadius.circular(100.r),
            borderColor: Colors.transparent,
            color: AppColors.blueColor,
            textColor: AppColors.whiteColor,
            icon: Icons.confirmation_number_outlined,
            onTap: () {
              controller.initializeBooking(event);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => UserEventGetTicketsSheet(event: event),
              );
            },
          ),
        ],
      ),
    );
  }
}
