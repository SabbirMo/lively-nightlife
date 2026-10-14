import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/onboarding_view/model/vibe_model.dart';


class VibeSelectionController extends GetxController {
  final RxList<String> selectedVibes = <String>[].obs;

  final List<VibeModel> vibeList = const [
    VibeModel(title: 'EDM'),
    VibeModel(title: 'Hip Hop'),
    VibeModel(title: 'College'),
    VibeModel(title: 'Bars'),
    VibeModel(title: 'R&B'),
    VibeModel(title: 'Festivals'),
    VibeModel(title: 'Nightclubs'),
    VibeModel(title: 'Reggaeton'),
    VibeModel(title: 'Jazz'),
    VibeModel(title: 'Open Format'),
  ];

  bool isSelected(String title) {
    return selectedVibes.contains(title);
  }

  void toggleVibe(String title) {
    if (selectedVibes.contains(title)) {
      selectedVibes.remove(title);
    } else {
      selectedVibes.add(title);
    }
  }

  bool get canContinue => selectedVibes.length >= 3;
}