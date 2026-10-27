import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/auth_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/widgets/role_selector_widget.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Image.asset(
            ImagePath.bluehighlightedBackground,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  Center(child: Image.asset(ImagePath.applogo, height: 48.h)),

                  SizedBox(height: 40.h),

                  Obx(
                    () => RoleSelectorWidget(
                      selectedRole: controller.selectedRole.value,
                      onChanged: controller.changeRole,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  TextProperty(
                    text: 'Sign in to your Account',
                    fontFamily: 'Sora',
                    textColor: AppColors.blackColor,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                  ),

                  SizedBox(height: 8.h),

                  TextProperty(
                    text: 'Enter your email and password to log in ',
                    textColor: AppColors.greyColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),

                  SizedBox(height: 32.h),

                  CustomTextfield(
                    controller: controller.emailController,
                    fieldText: 'Enter your email',
                    fillColor: AppColors.whiteColor,
                    borderRadius: 10.r,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 20.h),

                  CustomTextfield(
                    controller: controller.passwordController,
                    fieldText: 'Enter your password',
                    fillColor: AppColors.whiteColor,
                    borderRadius: 10.r,
                    isPassword: true,
                  ),

                  SizedBox(height: 18.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: controller.toggleRememberMe,
                          child: Row(
                            children: [
                              Container(
                                width: 14.w,
                                height: 14.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.greyColor,
                                    width: 2.w,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                  color: controller.rememberMe.value
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                ),
                                child: controller.rememberMe.value
                                    ? Icon(
                                        Icons.check,
                                        size: 12.sp,
                                        color: AppColors.whiteColor,
                                      )
                                    : null,
                              ),
                              SizedBox(width: 8.w),
                              TextProperty(
                                text: 'Remember me',
                                textColor: AppColors.greyColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoute.forgetPassView);
                        },
                        child: TextProperty(
                          text: 'Forgot Password?',
                          textColor: AppColors.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40.h),

                  Obx(
                    () => CustomButton(
                      buttonWidth: double.infinity,
                      borderRadius: BorderRadius.circular(100.r),
                      isLoading: controller.isLoading.value,
                      text: 'Log In',
                      onTap: controller.login,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  Row(
                    children: [
                      // Expanded(child: Divider(color: AppColors.lightGreyColor,)),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 0.5.h,
                          color: AppColors.lightGreyColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: TextProperty(
                          text: 'Or',
                          textColor: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: 0.5.h,
                          color: AppColors.lightGreyColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  CustomButton(
                    iconImagePath: IconPath.googleLogoIcon,
                    text: 'Continue with Google',
                    textColor: AppColors.blackColor,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    onTap: controller.signInWithGoogle,
                  ),

                  SizedBox(height: 40.h),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 14.sp,
                            ),
                          ),
                          TextSpan(
                            text: "Sign Up",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(AppRoute.signUpView);
                              },
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
