import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/reset_password_flow_controller.dart';

class OtpView extends StatelessWidget {
  final VoidCallback? onNext;

  const OtpView({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextProperty(
              text: 'Check Your Email',
              textColor: AppColors.blackColor,
              fontSize: 32.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 8.h),
            Builder(
              builder: (context) {
                final flowController = Get.find<ResetPasswordFlowController>();
                final email = flowController.emailController.text.trim();
                return TextProperty(
                  text:
                      'We sent a verification code to ${email.isNotEmpty ? email : 'your email'}. Enter the code below.',
                  textColor: AppColors.greyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                );
              },
            ),
            SizedBox(height: 46.h),
            Center(
              child: Obx(() {
                final flowController = Get.find<ResetPasswordFlowController>();
                return OtpTextField(
                  borderWidth: 1.5.w,
                  cursorColor: AppColors.primaryColor,
                  showCursor: false,
                  numberOfFields: 4,
                  fieldWidth: 60.w,
                  fieldHeight: 60.h,
                  borderRadius: BorderRadius.circular(12.r),
                  enabledBorderColor: flowController.hasError.value
                      ? AppColors.redColor
                      : AppColors.defaultBorderColor,
                  focusedBorderColor: flowController.hasError.value
                      ? AppColors.redColor
                      : AppColors.primaryColor,
                  borderColor: flowController.hasError.value
                      ? AppColors.redColor
                      : AppColors.defaultBorderColor,
                  fillColor: flowController.hasError.value
                      ? AppColors.redColor.withValues(alpha: 0.05)
                      : Colors.transparent,
                  filled: true,
                  showFieldAsBox: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textStyle: TextStyle(
                    color: flowController.hasError.value
                        ? AppColors.redColor
                        : AppColors.blackColor,
                    fontFamily: 'Poppins',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  onCodeChanged: (String code) {
                    flowController.otpCode = code.trim();
                    if (flowController.hasError.value) {
                      flowController.hasError.value = false;
                      flowController.errorMessage.value = '';
                    }
                  },
                  onSubmit: (String value) {
                    flowController.otpCode = value.trim();
                    if (flowController.hasError.value) {
                      flowController.hasError.value = false;
                      flowController.errorMessage.value = '';
                    }
                  },
                );
              }),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Obx(() {
                final flowController = Get.find<ResetPasswordFlowController>();
                if (flowController.seconds.value > 0) {
                  return Text(
                    'Resend code in ${flowController.seconds.value}s',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.blackColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code?   ",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (flowController.isResending.value)
                        SizedBox(
                          width: 14.w,
                          height: 14.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: flowController.resendOtp,
                          child: Text(
                            'Resend',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: AppColors.primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  );
                }
              }),
            ),
            SizedBox(height: 46.h),
            Obx(() {
              final flowController = Get.find<ResetPasswordFlowController>();
              return CustomButton(
                color: flowController.hasError.value
                    ? AppColors.redColor
                    : AppColors.primaryColor,
                borderColor: Colors.transparent,
                isLoading: flowController.isLoading.value,
                text: flowController.hasError.value
                    ? 'Try again?'
                    : 'Verify Code',
                icon: Icons.arrow_forward,
                iconSize: 20.w,
                onTap: flowController.nextPage,
              );
            }),

            Obx(() {
              final flowController = Get.find<ResetPasswordFlowController>();
              if (flowController.hasError.value &&
                  flowController.errorMessage.value.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.redColor.withValues(alpha: 0.05),
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
                          text: flowController.errorMessage.value,
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
          ],
        ),
      ),
    );
  }
}
