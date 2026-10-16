import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/services/token_storage_service.dart';
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

    if (TokenStorageService.hasToken()) {
      final activeProfile = TokenStorageService.getActiveProfile();
      final bool isVenue = activeProfile == 'venue' || activeProfile == 'club';
      if (isVenue) {
        Get.offAllNamed(AppRoute.clubBottomNavbarView);
      } else {
        Get.offAllNamed(AppRoute.userBottomNavigationBarView);
      }
    } else {
      Get.offAllNamed(AppRoute.onboardingView);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
