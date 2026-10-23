class CommentModel {
  final String? id;
  final String? userId;
  final String? username;
  final String userName;
  final String comment;
  final String time;
  final String? profileImage;
  final DateTime? createdAt;

  CommentModel({
    this.id,
    this.userId,
    this.username,
    required this.userName,
    required this.comment,
    required this.time,
    this.profileImage,
    this.createdAt,
  });

  CommentModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? userName,
    String? comment,
    String? time,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userName: userName ?? this.userName,
      comment: comment ?? this.comment,
      time: time ?? this.time,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : null;

    String name = '';
    String? profilePic;
    String? userId;
    String? username;

    if (user != null) {
      userId = user['id']?.toString();
      username = user['username']?.toString();
      final first = user['first_name']?.toString().trim() ?? '';
      final last = user['last_name']?.toString().trim() ?? '';
      final full = '$first $last'.trim();
      name = full.isNotEmpty ? full : (username ?? '');
      profilePic = user['profile_image']?.toString();
    } else {
      userId = json['user_id']?.toString() ?? json['user']?.toString();
      username = json['username']?.toString();
      name = username ?? '';
    }

    final createdAt = json['created_at']?.toString();
    DateTime? dt;
    String timeAgo = '';
    if (createdAt != null && createdAt.isNotEmpty) {
      dt = DateTime.tryParse(createdAt);
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
      userId: userId,
      username: username,
      userName: name.isNotEmpty ? name : 'User',
      comment: json['text']?.toString() ?? json['comment']?.toString() ?? '',
      time: timeAgo.isNotEmpty ? timeAgo : 'Recently',
      profileImage: profilePic,
      createdAt: dt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CommentModel) return false;
    if (id != null && other.id != null) {
      return id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => id != null ? id.hashCode : super.hashCode;
}