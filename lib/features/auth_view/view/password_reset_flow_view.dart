import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/controller/reset_password_flow_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/view/forget_pass_view.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/widgets/create_new_pass_step_page.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/widgets/otp_view.dart';
import 'package:lively_nightlife_nightclub_party/features/auth_view/widgets/step_indicator.dart';

class PasswordResetFlowView extends StatelessWidget {
  const PasswordResetFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResetPasswordFlowController>();

    return Scaffold(
      backgroundColor: AppColors.defaultBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Image.asset(
            ImagePath.bluehighlightedBackground,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 84.h, 24.w, 48.h),
            child: Column(
              children: [
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (controller.currentStep.value == 0) {
                            Get.back();
                          } else {
                            controller.previousPage();
                          }
                        },
                        child: SvgPicture.asset(
                          IconPath.backButton,
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                      StepIndicator(
                        currentStep: controller.currentStep.value + 1,
                        totalSteps: ResetPasswordFlowController.totalSteps,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 26.h),
                Expanded(
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _buildCurrentStep(controller),
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

  Widget _buildCurrentStep(ResetPasswordFlowController controller) {
    switch (controller.currentStep.value) {
      case 1:
        return OtpView(
          key: const ValueKey('step_1_otp'),
          onNext: controller.nextPage,
        );
      case 2:
        return CreateNewPassStepPage(
          key: const ValueKey('step_2_new_pass'),
          onFinish: controller.nextPage,
        );
      case 0:
      default:
        return ForgetPassView(
          key: const ValueKey('step_0_forget'),
          onNext: controller.nextPage,
        );
    }
  }
}
