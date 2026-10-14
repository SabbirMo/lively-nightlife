import 'package:get/get.dart';
import 'club_post_model.dart';

class HeatZoneModel {
  final String id;
  final String clubName;

  final double latitude;
  final double longitude;

  final int capacity;
  final int ticketsSold;

  final double distance;

  final double top;
  final double left;

  final List<ClubPostModel> posts;

  final RxBool isFollowing = false.obs;

  HeatZoneModel({
    required this.id,
    required this.clubName,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.ticketsSold,
    required this.distance,
    required this.posts,
    required this.top,
    required this.left,
  });

  double get heatPercentage {
    return (ticketsSold / capacity) * 100;
  }

  String get heatLevel {
    if (heatPercentage >= 90) {
      return 'Insane';
    }

    if (heatPercentage >= 70) {
      return 'Hot';
    }

    if (heatPercentage >= 50) {
      return 'Active';
    }

    return 'Mild';
  }
}