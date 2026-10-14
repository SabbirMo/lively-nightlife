import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/controller/vibe_selection_controller.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/widget/vibe_chip_widget.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class VibeSelectionView
    extends GetView<VibeSelectionController> {
  const VibeSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Image.asset(
            ImagePath.onbImage4,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white54,
                    Colors.white,
                  ],
                  stops: [0.0, 0.60, 1.0],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ),
              child: Column(
                children: [
                  const Spacer(),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      ImagePath.applogo,
                      height: 42.h,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextProperty(
                      text: 'Your lively Vibe',
                      textColor: AppColors.blackColor,
                      fontSize: 38.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextProperty(
                      text:
                          'Pick at least 3 to personalize your feed and recommendations',
                      textColor: AppColors.greyColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Obx(
                    () => Wrap(
                      spacing: 10.w,
                      runSpacing: 12.h,
                      children: controller.vibeList.map((item) {
                        return VibeChipWidget(
                          title: item.title,
                          isSelected: controller.isSelected(
                            item.title,
                          ),
                          onTap: () {
                            controller.toggleVibe(
                              item.title,
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 36.h),

                  Obx(
                    () => CustomButton(
                      text: "Let's Party! 🎉",
                      borderRadius:
                          BorderRadius.circular(100.r),
                      color: controller.canContinue
                          ? AppColors.primaryColor
                          : AppColors.primaryColor
                              .withValues(alpha: .5),
                      onTap: () {
                        if (!controller.canContinue) {
                          return;
                        }

                        Get.offAllNamed(
                          AppRoute.loginView,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}