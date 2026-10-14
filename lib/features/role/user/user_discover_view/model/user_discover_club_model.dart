class UserDiscoverClubModel {
  final int id;
  final String name;
  final double rating;
  final String location;
  final String priceRange;
  final List<String> categories;
  final String followersCount;
  final int upcomingEventsCount;
  final String capacity;
  final bool isOpenNow;
  final String image;
  final String type; // 'club', 'event', 'people'

  const UserDiscoverClubModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.location,
    required this.priceRange,
    required this.categories,
    required this.followersCount,
    required this.upcomingEventsCount,
    required this.capacity,
    required this.isOpenNow,
    required this.image,
    required this.type,
  });
}
