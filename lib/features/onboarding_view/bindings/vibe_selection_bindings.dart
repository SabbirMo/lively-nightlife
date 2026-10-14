import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/controller/vibe_selection_controller.dart';


class VibeSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VibeSelectionController>(
      () => VibeSelectionController(),
    );
  }
}