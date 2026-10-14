class ClubEventModel {
  final String id;
  final String title;
  final String imagePath;
  final bool isOpen;
  final double rating;
  final String location;
  final String priceTier;
  final String rsvps;
  final String ticketsSold;
  final String revenue;

  ClubEventModel({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.isOpen,
    required this.rating,
    required this.location,
    required this.priceTier,
    required this.rsvps,
    required this.ticketsSold,
    required this.revenue,
  });
}
