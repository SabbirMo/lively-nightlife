import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/reset_password_flow_controller.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class ForgetPassView extends StatelessWidget {
  final VoidCallback onNext;

  const ForgetPassView({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextProperty(
            text: 'Forget Password?',
            textColor: AppColors.blackColor,
            fontSize: 32.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.h),
          TextProperty(
            text:
                'Don\'t worry! It happens. Please enter the email address associated with your account.',
            textColor: AppColors.greyColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 24.h),

          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: TextProperty(
          //     text: "Email",
          //     textColor: AppColors.blackColor,
          //     fontSize: 16.sp,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          // SizedBox(height: 8.h),
          Builder(
            builder: (context) {
              final flowController = Get.find<ResetPasswordFlowController>();
              return CustomTextfield(
                borderColor: AppColors.whiteColor.withAlpha(25),
                borderRadius: 12.r,
                isPassword: false,
                keyboardType: TextInputType.emailAddress,
                // prefixIcon: IconPath.mailIcon,
                fieldText: 'Enter your email',
                controller: flowController.emailController,
              );
            },
          ),
          SizedBox(height: 40.h),
          Obx(() {
            final flowController = Get.find<ResetPasswordFlowController>();
            return CustomButton(
              isShadowNeed: false,
              isLoading: flowController.isLoading.value,
              iconSize: 20.w,
              text: 'Send',
              onTap: flowController.nextPage,
            );
          }),
          SizedBox(height: 16.h),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Remember your password?   ",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.blackColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.toNamed(AppRoute.loginView);
                      },
                    text: "Sign in",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
