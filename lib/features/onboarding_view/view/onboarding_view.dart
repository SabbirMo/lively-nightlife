import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/icon_path.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/widget/onboading_indicator.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/widget/onboarding_page.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import '../controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.onboardingList.length,
            itemBuilder: (_, index) {
              return OnboardingPage(item: controller.onboardingList[index]);
            },
          ),

          Positioned(
            left: 24.w,
            right: 24.w,
            bottom: 40.h,
            child: Obx(() {
              final item =
                  controller.onboardingList[controller.currentIndex.value];

              final isLastPage =
                  controller.currentIndex.value ==
                  controller.onboardingList.length - 1;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(ImagePath.applogo, height: 36.h),

                  SizedBox(height: 32.h),

                  TextProperty(
                    text: item.title,
                    textColor: AppColors.blackColor,
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w700,
                    lineHeight: 1.2,
                  ),

                  SizedBox(height: 14.h),

                  TextProperty(
                    text: item.description,
                    textColor: AppColors.greyColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    lineHeight: 1.5,
                  ),

                  SizedBox(height: 28.h),

                  CustomButton(
                    text: 'Continue',
                    // text: isLastPage
                    //     ? 'Get Started'
                    //     : 'Continue',
                    rightIconPath: IconPath.rightArrowIcon,
                    borderRadius: BorderRadius.circular(100.r),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    onTap: () {

                      // add async before {
                      // await LocalStorageService.instance
                      // .saveOnboardingStatus(true);
                      // it will skip the onboarding screen next time user opens the app
                      if (isLastPage) {
                        Get.offNamed(AppRoute.permissionView);
                      } else {
                        controller.nextPage();
                      }
                    },
                  ),

                  SizedBox(height: 32.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.onboardingList.length,
                      (index) => OnboardingIndicator(
                        isActive: controller.currentIndex.value == index,
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextProperty(
                          text: 'Already have an account? ',
                          textColor: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoute.loginView);
                          },
                          child: TextProperty(
                            text: 'Sign In',
                            textColor: AppColors.primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
