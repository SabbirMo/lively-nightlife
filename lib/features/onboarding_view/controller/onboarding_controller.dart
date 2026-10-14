import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/constants/image_path.dart';
import '../model/onboarding_model.dart';

class OnboardingController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final PageController pageController = PageController();

  List<OnboardingModel> onboardingList = [
    OnboardingModel(
      image: ImagePath.onbImage1,
      title: 'Discover Nightlife\nNear You',
      description:
          'Find the hottest clubs, events, and parties in real-time using our live Heat Map',
    ),
    OnboardingModel(
      image: ImagePath.onbImage2,
      title: 'Follow the Heat',
      description:
          'See where everyone is going. Our real-time Heat Map shows live nightlife activity across the city.',
    ),
    OnboardingModel(
      image: ImagePath.onbImage3,
      title: 'Events & Tickets',
      description:
          'Discover upcoming events, buy tickets, and RSVP — all in one place',
    ),
    OnboardingModel(
      image: ImagePath.onbImage4,
      title: 'Real Nightlife\nStories',
      description:
          '48-hour user-tagged stories from real people at real clubs right now',
    ),
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  Future<void> nextPage() async {
    if (currentIndex.value < onboardingList.length - 1) {
      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}