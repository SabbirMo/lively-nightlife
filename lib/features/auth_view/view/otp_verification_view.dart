import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';

import '../controller/otp_controller.dart';

class OtpVerificationView extends GetView<OtpController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            controller.hasError.value
                ? ImagePath.errorHighlightedBackground
                : ImagePath.bluehighlightedBackground,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    GestureDetector(
                      onTap: Get.back,
                      child: SvgPicture.asset(
                        IconPath.backArrowIcon,
                        height: 24.h,
                      ),
                    ),

                    SizedBox(height: 60.h),

                    TextProperty(
                      text: 'OTP Code \nVerification',
                      textColor: AppColors.blackColor,
                      fontSize: 32.sp,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w700,
                    ),

                    SizedBox(height: 12.h),

                    TextProperty(
                      text: controller.email.isNotEmpty
                          ? 'Code has been sent to your email address \n${controller.email}.'
                          : 'Code has been sent to your email address.',
                      textColor: AppColors.greyColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),

                    SizedBox(height: 50.h),

                    Center(
                      child: Obx(
                        () => OtpTextField(
                          cursorColor: AppColors.primaryColor,
                          showCursor: false,
                          numberOfFields: 4,
                          fieldWidth: 60.w,
                          fieldHeight: 60.h,
                          borderRadius: BorderRadius.circular(12.r),
                          enabledBorderColor: controller.hasError.value
                              ? AppColors.redColor
                              : AppColors.defaultBorderColor,
                          focusedBorderColor: controller.hasError.value
                              ? AppColors.redColor
                              : AppColors.primaryColor,
                          borderColor: controller.hasError.value
                              ? AppColors.redColor
                              : AppColors.defaultBorderColor,
                          fillColor: controller.hasError.value
                              ? AppColors.redColor.withValues(alpha: 0.05)
                              : Colors.transparent,
                          filled: true,
                          showFieldAsBox: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textStyle: TextStyle(
                            color: controller.hasError.value
                                ? AppColors.redColor
                                : AppColors.blackColor,
                            fontFamily: 'Poppins',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          onSubmit: controller.updateOtp,
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    Center(
                      child: Obx(() {
                        if (controller.isResending.value) {
                          return SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              color: AppColors.primaryColor,
                            ),
                          );
                        }

                        return controller.seconds.value > 0
                            ? TextProperty(
                                text:
                                    'Resend code in ${controller.seconds.value}s',
                                textColor: AppColors.greyColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              )
                            : RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Didn\'t receive a code?    ',
                                      style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Resend Code',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = controller.resendOtp,
                                    ),
                                  ],
                                ),
                              );
                      }),
                    ),
                    SizedBox(height: 80),
                    // const Spacer(),
                    Obx(
                      () => CustomButton(
                        borderRadius: BorderRadius.circular(100.r),
                        isLoading: controller.isLoading.value,
                        color: controller.hasError.value
                            ? AppColors.redColor
                            : AppColors.primaryColor,
                        text: controller.hasError.value
                            ? 'Try again?'
                            : 'Verify & Continue',
                        onTap: controller.verifyOtp,
                      ),
                    ),

                    Obx(() {
                      if (controller.hasError.value &&
                          controller.errorMessage.value.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECEC),
                              borderRadius: BorderRadius.circular(100.r),
                              border: Border.all(
                                color: AppColors.redColor.withValues(alpha: 0.15),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.redColor,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                TextProperty(
                                  text: controller.errorMessage.value,
                                  textColor: AppColors.redColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
