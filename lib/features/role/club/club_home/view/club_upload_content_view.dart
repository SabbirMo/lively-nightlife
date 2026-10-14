import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_upload_content_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/upload_step_one.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/upload_step_three.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/upload_step_two.dart';

class ClubUploadContentView extends GetView<ClubUploadContentController> {
  const ClubUploadContentView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ClubUploadContentController());

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Image.asset(
            ImagePath.bluehighlightedBackground2,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Obx(() {
                      switch (controller.currentStep.value) {
                        case 2:
                          return const UploadStepTwo();
                        case 3:
                          return const UploadStepThree();
                        default:
                          return const UploadStepOne();
                      }
                    }),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Obx(
                    () => CustomButton(
                      text: controller.currentStep.value < 3
                          ? 'Next'
                          : 'Publish Post',
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(100.r),
                      onTap: () {
                        if (controller.currentStep.value < 3) {
                          controller.nextStep();
                        } else {
                          controller.publishPost();
                        }
                      },
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: controller.previousStep,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  child: SvgPicture.asset(
                    IconPath.backArrowIcon,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      AppColors.blackColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Obx(
                    () => TextProperty(
                      text: controller.currentStep.value == 1
                          ? 'Write Caption'
                          : 'Add Details',
                      textColor: AppColors.blackColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40.w),
            ],
          ),
          SizedBox(height: 12.h),
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() {
      final step = controller.currentStep.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 6.w),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: step >= 2 ? AppColors.primaryColor : AppColors.grey50Color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 6.w),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: step >= 3 ? AppColors.primaryColor : AppColors.grey50Color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      );
    });
  }
}
