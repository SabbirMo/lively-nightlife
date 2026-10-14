import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/password_controller.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class CreateNewPassStepPage extends StatelessWidget {
  final VoidCallback onFinish;

  const CreateNewPassStepPage({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    final passwordController = Get.find<PasswordController>(
      tag: 'createPassword',
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextProperty(
            text: 'Set New Password',
            textColor: AppColors.blackColor,
            fontSize: 32.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 8.h),
          TextProperty(
            text:
                'Your new password must be different from previously used passwords.',
            textColor: AppColors.greyColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 32.h),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: TextProperty(
          //     text: 'New Password',
          //     textColor: AppColors.whiteColor,
          //     fontSize: 16.sp,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          // SizedBox(height: 8.h),
          CustomTextfield(
            // borderColor: AppColors.defaultBorderColor,
            borderRadius: 12.r,
            isPassword: true,
            prefixIcon: IconPath.lockIcon,
            fieldText: 'New password',
            onChanged: passwordController.onPasswordChanged,
          ),
          SizedBox(height: 32.h),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: TextProperty(
          //     text: 'Confirm New Password',
          //     textColor: AppColors.whiteColor,
          //     fontSize: 16.sp,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          // SizedBox(height: 8.h),
          CustomTextfield(
            // borderColor: AppColors.defaultBorderColor,
            borderRadius: 12.r,
            isPassword: true,
            prefixIcon: IconPath.lockIcon,
            fieldText: 'Confirm new password',
            onChanged: passwordController.onConfirmPasswordChanged,
          ),
          SizedBox(height: 32.h),
          CustomButton(
            isShadowNeed: false,
            text: 'Reset Password',
            // icon: Icons.arrow_forward,
            iconSize: 20.w,
            onTap: onFinish,
          ),
          SizedBox(height: 16.h),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Remember your password?   ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: AppColors.blackColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.toNamed(AppRoute.loginView),
                    text: 'Sign in',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14.sp,
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
