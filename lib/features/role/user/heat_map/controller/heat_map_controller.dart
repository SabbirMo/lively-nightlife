import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/model/club_post_model.dart';
import 'package:lively_nightlife_nightclub_party/features/role/user/heat_map/model/heat_zone_model.dart';
import 'package:share_plus/share_plus.dart';

class HeatMapController extends GetxController {
  final RxInt selectedTab = 0.obs;
  final draggableController = DraggableScrollableController();
  final Rx<HeatZoneModel?> selectedZone = Rx<HeatZoneModel?>(null);
  final searchController = TextEditingController();
  final searchText = ''.obs;
  final showClubs = true.obs;
  final showAreas = false.obs;
  final selectedDistance = 10.obs;
  final selectedHeat = ''.obs;

  void updateSearch(String value) {
    searchText.value = value;
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  Future<void> selectZone(HeatZoneModel zone) async {
    selectedZone.value = zone;
    await draggableController.animateTo(
      .55,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  void clearZone() {
    selectedZone.value = null;
  }

  final RxList<HeatZoneModel> zones = <HeatZoneModel>[
    HeatZoneModel(
      id: '1',
      clubName: 'Story Miami',
      latitude: 25.774,
      longitude: -80.190,
      capacity: 100,
      ticketsSold: 94,
      distance: 1.2,
      top: 420,
      left: 120,
      posts: [
        ClubPostModel(
          id: '1',
          mediaUrl: 'assets/images/feedImage.png',
          isVideo: true,
          caption: 'DJ starts at midnight 🔥',
          time: '1h',
        ),
        ClubPostModel(
          id: '2',
          mediaUrl: 'assets/images/feedImage.png',
          isVideo: false,
          caption: 'Packed dance floor tonight',
          time: '30m',
        ),
      ],
    ),

    HeatZoneModel(
      id: '2',
      clubName: 'LIV Miami',
      latitude: 25.779,
      longitude: -80.182,
      capacity: 100,
      ticketsSold: 82,
      distance: 2.5,
      top: 260,
      left: 25,
      posts: [
        ClubPostModel(
          id: '3',
          mediaUrl: 'assets/images/feedImage.png',
          isVideo: false,
          caption: 'Tonight is crazy 🚀',
          time: '1h',
        ),
      ],
    ),

    HeatZoneModel(
      id: '3',
      clubName: 'Club Space',
      latitude: 25.768,
      longitude: -80.200,
      capacity: 100,
      ticketsSold: 71,
      distance: 4.3,
      top: 230,
      left: 260,
      posts: [
        ClubPostModel(
          id: '4',
          mediaUrl: 'assets/images/feedImage.png',
          isVideo: false,
          caption: 'Weekend vibes 🎉',
          time: '5h',
        ),
      ],
    ),

    HeatZoneModel(
      id: '4',
      clubName: 'E11EVEN',
      latitude: 25.784,
      longitude: -80.175,
      capacity: 100,
      ticketsSold: 45,
      distance: 5.0,
      top: 230,
      left: 260,
      posts: [
        ClubPostModel(
          id: '5',
          mediaUrl: 'assets/images/feedImage.png',
          isVideo: false,
          caption: 'Open now 🍾',
          time: '30m',
        ),
      ],
    ),
  ].obs;

  List<HeatZoneModel> get filteredZones {
    if (searchText.value.isEmpty) {
      return zones;
    }
    return zones.where((zone) {
      return zone.clubName.toLowerCase().contains(
        searchText.value.toLowerCase(),
      );
    }).toList();
  }

  List<HeatZoneModel> get visibleZones {
    var result = filteredZones;

    /// DISTANCE
    result = result.where((zone) {
      return zone.distance <= selectedDistance.value;
    }).toList();

    /// HEAT FILTER
    if (selectedHeat.value.isNotEmpty) {
      result = result.where((zone) {
        return zone.heatLevel == selectedHeat.value;
      }).toList();
    }
    return result;
  }


  Future<void> shareExternally() async {
  await Share.share(
    'Check out this nightlife post on Lively!',
  );
}

void shareInApp(String userName) {
  Get.back();

  Get.snackbar(
    'Shared',
    'Post shared with $userName',
  );
}


  int get activeNow => zones.fold(0, (sum, item) => sum + item.ticketsSold);
  int get hotEvents => zones.where((e) => e.heatPercentage >= 70).length;
  int get clubsOpen => zones.length;
  int get heatZonesCount => zones.length;
}
