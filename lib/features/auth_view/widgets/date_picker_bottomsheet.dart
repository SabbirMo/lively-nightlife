import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/auth_controller.dart';

class DobPickerBottomSheet extends StatelessWidget {
  const DobPickerBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<AuthController>();

    DateTime selectedDate =
        DateTime.now().subtract(
      const Duration(days: 365 * 20),
    );

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor,
              borderRadius:
                  BorderRadius.circular(100.r),
            ),
          ),

          SizedBox(height: 20.h),

          TextProperty(
            text: 'Select Date of Birth',
            textColor: AppColors.blackColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),

          SizedBox(height: 20.h),

          DatePickerWidget(
            looping: false,
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
            initialDate: selectedDate,
            dateFormat:
                "dd-MMMM-yyyy",
            locale: DatePicker.localeFromString(
              'en',
            ),
            onChange: (date, _) {
              selectedDate = date;
            },
            pickerTheme:
                const DateTimePickerTheme(
              backgroundColor:
                  Colors.white,
            ),
          ),

          SizedBox(height: 20.h),

          CustomButton(
            text: 'Confirm Date',
            onTap: () {
              controller.selectDate(
                selectedDate,
              );

              Get.back();
            },
          ),
        ],
      ),
    );
  }
}