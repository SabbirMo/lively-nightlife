import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {

  late AnimationController animationController;

  late Animation<Offset> logoSlide;
  late Animation<double> logoOpacity;

  final isLogoBlack = false.obs;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );

    logoSlide = TweenSequence<Offset>(
      [
        TweenSequenceItem(
          tween: Tween<Offset>(
            begin: const Offset(-1.2, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic)),
          weight: 15,
        ),
        TweenSequenceItem(
          tween: ConstantTween<Offset>(Offset.zero),
          weight: 70,
        ),
        TweenSequenceItem(
          tween: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0, 1.2),
          ).chain(CurveTween(curve: Curves.easeInCubic)),
          weight: 30,
        ),
      ],
    ).animate(animationController);

    logoOpacity = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: ConstantTween<double>(1),
          weight: 85,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1,
            end: 0,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 15,
        ),
      ],
    ).animate(animationController);

    startSplash();
  }

  void startSplash() async {
    final animationFuture = animationController.forward();

    await Future<void>.delayed(const Duration(milliseconds: 1250));

    for (var index = 0; index < 4; index++) {
      if (isClosed) {
        return;
      }

      isLogoBlack.value = index.isEven;
      await Future<void>.delayed(const Duration(milliseconds: 1250));
    }

    if (isClosed) {
      return;
    }

    await animationFuture;
 
    if (isClosed) {
      return;
    }

    Get.toNamed(AppRoute.onboardingView);

    // final GetStorage storage = GetStorage();
    // final bool isLoggedIn = storage.read<bool>('is_logged_in') ?? false;
    // final authService = Get.find<AuthService>();
    // if (isLoggedIn && authService.hasCompletedOnboarding()) {
    //   Get.offAllNamed(AppRoute.bottomNavigationBarView);
    // } else if (isLoggedIn) {
    //   Get.offAllNamed(AppRoute.onboardingView);
    // } else {
    //   Get.offAllNamed(AppRoute.getStartedView);
    // }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
