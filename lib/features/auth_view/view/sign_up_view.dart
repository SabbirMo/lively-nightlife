import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';

import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/auth_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/models/auth_role.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/widgets/date_picker_bottomsheet.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/widgets/role_selector_widget.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

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
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: Get.back,
                        child: SvgPicture.asset(
                          IconPath.backArrowIcon,
                          height: 24.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    TextProperty(
                      text: 'Join the Party',
                      textColor: AppColors.blackColor,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                    ),

                    SizedBox(height: 12.h),

                    TextProperty(
                      text: 'Create your NIGHTLIFE account',
                      textColor: AppColors.greyColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),

                    SizedBox(height: 40.h),

                    RoleSelectorWidget(
                      selectedRole: controller.selectedRole.value,
                      onChanged: controller.changeRole,
                    ),

                    SizedBox(height: 32.h),

                    if (controller.selectedRole.value == AuthRole.user) ...[
                      // _buildLabel('First Name'),
                      CustomTextfield(
                        controller: controller.firstNameController,
                        fieldText: 'Enter first name',
                        fillColor: AppColors.whiteColor,
                        borderRadius: 10.r,
                      ),

                      SizedBox(height: 16.h),

                      // _buildLabel('Last Name'),
                      CustomTextfield(
                        controller: controller.lastNameController,
                        fieldText: 'Enter last name',
                        fillColor: AppColors.whiteColor,
                        borderRadius: 10.r,
                      ),

                      SizedBox(height: 16.h),

                      // _buildLabel('Date of Birth'),
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            const DobPickerBottomSheet(),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        },
                        child: AbsorbPointer(
                          child: CustomTextfield(
                            suffixIcon: SvgPicture.asset(IconPath.calendarIcon),
                            controller: controller.dobController,
                            fieldText: 'Enter date of birth',
                            fillColor: AppColors.whiteColor,
                            borderRadius: 10.r,
                          ),
                        ),
                      ),
                    ],

                    if (controller.selectedRole.value == AuthRole.club) ...[
                      // _buildLabel('Club Name'),
                      CustomTextfield(
                        controller: controller.clubNameController,
                        fieldText: 'Enter club name',
                        fillColor: AppColors.whiteColor,
                        borderRadius: 10.r,
                      ),

                      SizedBox(height: 16.h),

                      // _buildLabel('Phone Number'),
                      CustomTextfield(
                        controller: controller.phoneController,
                        fieldText: 'Enter phone',
                        fillColor: AppColors.whiteColor,
                        borderRadius: 10.r,
                      ),
                    ],

                    SizedBox(height: 16.h),

                    // _buildLabel('Email'),
                    CustomTextfield(
                      controller: controller.signupEmailController,
                      fieldText: 'Enter email',
                      fillColor: AppColors.whiteColor,
                      borderRadius: 10.r,
                    ),

                    SizedBox(height: 16.h),

                    // _buildLabel('Password'),
                    CustomTextfield(
                      controller: controller.signupPasswordController,
                      fieldText: 'Enter password',
                      fillColor: AppColors.whiteColor,
                      borderRadius: 10.r,
                      isPassword: true,
                    ),

                    SizedBox(height: 16.h),

                    // _buildLabel('Confirm Password'),
                    CustomTextfield(
                      controller: controller.confirmPasswordController,
                      fieldText: 'Confirm password',
                      fillColor: AppColors.whiteColor,
                      borderRadius: 10.r,
                      isPassword: true,
                    ),

                    SizedBox(height: 40.h),

                    CustomButton(
                      borderRadius: BorderRadius.circular(100.r),
                      isLoading: controller.isLoading.value,
                      text: 'Register',
                      onTap: controller.register,
                    ),

                    SizedBox(height: 52.h),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: AppColors.greyColor,
                                fontSize: 14.sp,
                              ),
                            ),
                            TextSpan(
                              text: 'Sign In',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.back();
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
          ),
        ],
      ),
    );
  }
}
