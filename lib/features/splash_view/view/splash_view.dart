import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/features/splash_view/controller/splash_view_controller.dart';

class SplashView extends StatelessWidget {
  final controller = Get.find<SplashController>();

  SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.logoOpacity,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                ImagePath.splashbackground,
                fit: BoxFit.cover,
                // filterQuality: FilterQuality.high,
              ),
              // Opacity(
              //   opacity: controller.logoOpacity.value,
              //   child: const ColoredBox(
              //     color: AppColors.primaryColor,
              //   ),
              // ),
              Center(
                child: FadeTransition(
                  opacity: controller.logoOpacity,
                  child: 
                  // SlideTransition(
                  //   position: controller.logoSlide,
                  //   child: 
                    AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        child: Image.asset(
                          ImagePath.applogo,
                          key: const ValueKey('logo-original'),
                          width: 300.w,
                          filterQuality: FilterQuality.high,
                        ),
                        
                      ),
                  ),
                ),
              // ),
            ],
          ),
        );
      },
    );
  }
}
