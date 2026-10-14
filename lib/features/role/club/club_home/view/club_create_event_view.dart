import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/controller/club_create_event_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/create_event_step_one.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/create_event_step_two.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/create_event_step_three.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/create_event_step_four.dart';
import 'package:lively_nightlife_nightclub_party/features/role/club/club_home/widget/create_event_step_five.dart';

class ClubCreateEventView extends GetView<ClubCreateEventController> {
  const ClubCreateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ClubCreateEventController());

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
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Obx(() {
                      switch (controller.currentStep.value) {
                        case 1:
                          return const CreateEventStepOne();
                        case 2:
                          return const CreateEventStepTwo();
                        case 3:
                          return const CreateEventStepThree();
                        case 4:
                          return const CreateEventStepFour();
                        case 5:
                          return const CreateEventStepFive();
                        default:
                          return const CreateEventStepOne();
                      }
                    }),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Obx(() => CustomButton(
                    text: controller.currentStep.value == 5
                        ? (controller.isEditMode.value ? 'Update Event' : 'Publish Event')
                        : 'Next',
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(100.r),
                    onTap: controller.nextStep,
                  )),
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
                    colorFilter: const ColorFilter.mode(AppColors.blackColor, BlendMode.srcIn),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Obx(() {
                    String title = controller.isEditMode.value ? 'Edit Event Details' : 'Event Basics';
                    if (controller.currentStep.value > 1) {
                      title = controller.isEditMode.value
                          ? 'Edit Event Details (Step ${controller.currentStep.value})'
                          : 'Event Details (Step ${controller.currentStep.value})';
                    }
                    return TextProperty(
                      text: title,
                      textColor: AppColors.blackColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    );
                  }),
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
        children: List.generate(6, (index) {
          final isFilled = step > index;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: 25.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isFilled ? AppColors.primaryColor : AppColors.grey50Color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          );
        }),
      );
    });
  }
}
