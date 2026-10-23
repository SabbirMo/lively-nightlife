class CommentModel {
  final String? id;
  final String userName;
  final String comment;
  final String time;
  final String? profileImage;

  CommentModel({
    this.id,
    required this.userName,
    required this.comment,
    required this.time,
    this.profileImage,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : null;

    String name = '';
    String? profilePic;

    if (user != null) {
      final first = user['first_name']?.toString().trim() ?? '';
      final last = user['last_name']?.toString().trim() ?? '';
      final full = '$first $last'.trim();
      name = full.isNotEmpty ? full : (user['username']?.toString() ?? '');
      profilePic = user['profile_image']?.toString();
    } else {
      name = json['username']?.toString() ?? '';
    }

    final createdAt = json['created_at']?.toString();
    String timeAgo = '';
    if (createdAt != null && createdAt.isNotEmpty) {
      final dt = DateTime.tryParse(createdAt);
      if (dt != null) {
        final diff = DateTime.now().difference(dt.toLocal());
        if (diff.inSeconds < 60) {
          timeAgo = 'Just now';
        } else if (diff.inMinutes < 60) {
          timeAgo = '${diff.inMinutes}m';
        } else if (diff.inHours < 24) {
          timeAgo = '${diff.inHours}h';
        } else {
          timeAgo = '${diff.inDays}d';
        }
      }
    }

    return CommentModel(
      id: json['id']?.toString(),
      userName: name.isNotEmpty ? name : 'User',
      comment: json['text']?.toString() ?? json['comment']?.toString() ?? '',
      time: timeAgo.isNotEmpty ? timeAgo : 'Recently',
      profileImage: profilePic,
    );
  }
}