import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:lively_nightlife_nightclub_party/routes/app_routes.dart';
import '../model/user_discover_club_model.dart';

class UserDiscoverController extends GetxController {
  final RxInt selectedTab = 0.obs; // 0: All, 1: Clubs, 2: Events, 3: People
  final RxString searchQuery = ''.obs;
  final searchController = TextEditingController();

  final RxList<UserDiscoverClubModel> clubsList = <UserDiscoverClubModel>[].obs;
  final RxList<UserDiscoverClubModel> filteredClubs = <UserDiscoverClubModel>[].obs;

  @override
  void onInit() {
    _loadDemoData();
    filterItems();

    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    // Re-filter when tab or search query changes
    ever(selectedTab, (_) => filterItems());
    ever(searchQuery, (_) => filterItems());

    super.onInit();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void filterItems() {
    String query = searchQuery.value.toLowerCase();
    List<UserDiscoverClubModel> result = clubsList;

    // Filter by Tab type
    if (selectedTab.value == 1) {
      result = result.where((item) => item.type == 'club').toList();
    } else if (selectedTab.value == 2) {
      result = result.where((item) => item.type == 'event').toList();
    } else if (selectedTab.value == 3) {
      result = result.where((item) => item.type == 'people').toList();
    }

    // Filter by Search Query
    if (query.isNotEmpty) {
      result = result.where((item) {
        return item.name.toLowerCase().contains(query) ||
            item.location.toLowerCase().contains(query) ||
            item.categories.any((cat) => cat.toLowerCase().contains(query));
      }).toList();
    }

    filteredClubs.assignAll(result);
  }

  void onClubTap(UserDiscoverClubModel club) {
    Get.toNamed(
      AppRoute.userClubDetailsView,
      arguments: club,
    );
  }

  void _loadDemoData() {
    clubsList.assignAll([
      // Clubs
      const UserDiscoverClubModel(
        id: 1,
        name: 'Omnia Nightclub',
        rating: 4.8,
        location: 'Las Vegas, NV',
        priceRange: r'$$$',
        categories: ['EDM', 'Hip Hop', 'Bars'],
        followersCount: '892k',
        upcomingEventsCount: 8,
        capacity: '3,000 cap.',
        isOpenNow: true,
        image: ImagePath.feedImage,
        type: 'club',
      ),
      const UserDiscoverClubModel(
        id: 2,
        name: 'Hakkasan Nightclub',
        rating: 4.7,
        location: 'Las Vegas, NV',
        priceRange: r'$$$$',
        categories: ['EDM', 'Dance', 'Lounge'],
        followersCount: '450k',
        upcomingEventsCount: 5,
        capacity: '2,500 cap.',
        isOpenNow: true,
        image: ImagePath.feedImage,
        type: 'club',
      ),
      const UserDiscoverClubModel(
        id: 3,
        name: 'XS Nightclub',
        rating: 4.9,
        location: 'Las Vegas, NV',
        priceRange: r'$$$$',
        categories: ['House', 'EDM', 'Pool Club'],
        followersCount: '620k',
        upcomingEventsCount: 4,
        capacity: '4,000 cap.',
        isOpenNow: false,
        image: ImagePath.feedImage,
        type: 'club',
      ),
      // Events
      const UserDiscoverClubModel(
        id: 4,
        name: 'Neon Dreams Festival',
        rating: 4.9,
        location: 'Las Vegas, NV',
        priceRange: r'$$',
        categories: ['Festival', 'EDM', 'Lights'],
        followersCount: '120k',
        upcomingEventsCount: 1,
        capacity: '10,000 cap.',
        isOpenNow: true,
        image: ImagePath.feedImage,
        type: 'event',
      ),
      const UserDiscoverClubModel(
        id: 5,
        name: 'Summer Vibe Beats',
        rating: 4.5,
        location: 'Los Angeles, CA',
        priceRange: r'$$$',
        categories: ['Pool Party', 'Hip Hop', 'Vibes'],
        followersCount: '80k',
        upcomingEventsCount: 1,
        capacity: '1,500 cap.',
        isOpenNow: true,
        image: ImagePath.feedImage,
        type: 'event',
      ),
      // People
      const UserDiscoverClubModel(
        id: 6,
        name: 'DJ Alexander',
        rating: 4.8,
        location: 'Miami, FL',
        priceRange: r'$$',
        categories: ['DJ', 'Producer', 'Techno'],
        followersCount: '2.5M',
        upcomingEventsCount: 12,
        capacity: 'Artist',
        isOpenNow: true,
        image: ImagePath.feedImage,
        type: 'people',
      ),
      const UserDiscoverClubModel(
        id: 7,
        name: 'Sarah Jenkins',
        rating: 4.6,
        location: 'Las Vegas, NV',
        priceRange: r'$',
        categories: ['Vocalist', 'EDM', 'Live'],
        followersCount: '180k',
        upcomingEventsCount: 3,
        capacity: 'Artist',
        isOpenNow: false,
        image: ImagePath.feedImage,
        type: 'people',
      ),
    ]);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
