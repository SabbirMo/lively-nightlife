enum ActivityType { follower, ticket, review, warning }

class ClubActivityModel {
  final ActivityType type;
  final String message;
  final String time;

  ClubActivityModel({
    required this.type,
    required this.message,
    required this.time,
  });
}
