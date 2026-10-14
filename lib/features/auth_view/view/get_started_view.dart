import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/custom_button.dart';
import 'package:lively_nightlife_nightclub_party/core/common/widgets/text_property.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/colors.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            ImagePath.bluehighlightedBackground,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    ImagePath.applogo,
                    width: 200,
                    filterQuality: FilterQuality.high,
                  ),
                  Spacer(),
                  Center(
                    child: TextProperty(
                      text: 'Discover What\'s Popn in Seconds',
                      textColor: AppColors.whiteColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: TextProperty(
                      text:
                          'Rate movies+shows, check out friend favorites, and get personalized picks instantly.',
                      textColor: AppColors.lightGreyColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                    text: 'Get Started',
                    onTap: () {
                      Get.toNamed(AppRoute.signUpView);
                    },
                    icon: Icons.arrow_forward_rounded,
                    iconSize: 20.w,
                    borderColor: AppColors.whiteColor.withAlpha(13),
                    isShadowNeed: true,
                  ),
                  SizedBox(height: 16.h),
                  CustomButton(
                    text: 'Sign In',
                    onTap: () {
                      Get.toNamed(AppRoute.loginView);
                    },
                    iconSize: 20.w,
                    color: AppColors.whiteColor.withAlpha(13),
                    borderColor: AppColors.whiteColor.withAlpha(25),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
