import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_textfield.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Faded Top Blue Background Highlight
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 220.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFDCE9FE).withValues(alpha: 0.6),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Back Button + Title)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 22.sp,
                          color: AppColors.blackColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      TextProperty(
                        text: 'Change Password',
                        textColor: AppColors.blackColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Sora',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        TextProperty(
                          text: 'Create a new password',
                          textColor: AppColors.blackColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Sora',
                        ),
                        SizedBox(height: 6.h),
                        TextProperty(
                          text:
                              'Your new password must be at least 8 characters and different from your previously used password.',
                          textColor: AppColors.greyColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(height: 28.h),

                        // Old Password Field
                        _buildLabel('Old Password'),
                        CustomTextfield(
                          controller: controller.oldPasswordController,
                          fieldText: 'Enter your old password',
                          isPassword: true,
                          prefixIcon: IconPath.lock,
                          fillColor: const Color(0xFFF8FAFC),
                          borderColor: const Color(0xFFE2E8F0),
                          borderRadius: 12.r,
                        ),
                        SizedBox(height: 20.h),

                        // New Password Field
                        _buildLabel('New Password'),
                        CustomTextfield(
                          controller: controller.newPasswordController,
                          fieldText: 'Enter your new password',
                          isPassword: true,
                          prefixIcon: IconPath.lock,
                          fillColor: const Color(0xFFF8FAFC),
                          borderColor: const Color(0xFFE2E8F0),
                          borderRadius: 12.r,
                        ),
                        SizedBox(height: 20.h),

                        // Confirm Password Field
                        _buildLabel('Confirm Password'),
                        CustomTextfield(
                          controller: controller.confirmPasswordController,
                          fieldText: 'Confirm your new password',
                          isPassword: true,
                          prefixIcon: IconPath.lock,
                          fillColor: const Color(0xFFF8FAFC),
                          borderColor: const Color(0xFFE2E8F0),
                          borderRadius: 12.r,
                        ),
                        SizedBox(height: 36.h),

                        // Change Password Button
                        Obx(
                          () => CustomButton(
                            text: 'Change Password',
                            isLoading: controller.isLoading.value,
                            borderRadius: BorderRadius.circular(100.r),
                            onTap: controller.changePassword,
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: TextProperty(
        text: label,
        textColor: AppColors.blackColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'Sora',
      ),
    );
  }
}
