class UserStoryModel {
  final String id;
  final String name;
  final String avatar;
  final bool isYourStory;
  final String? mediaPath;
  final bool isVideo;

  const UserStoryModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isYourStory,
    this.mediaPath,
    this.isVideo = false,
  });

  UserStoryModel copyWith({
    String? id,
    String? name,
    String? avatar,
    bool? isYourStory,
    String? mediaPath,
    bool? isVideo,
  }) {
    return UserStoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isYourStory: isYourStory ?? this.isYourStory,
      mediaPath: mediaPath ?? this.mediaPath,
      isVideo: isVideo ?? this.isVideo,
    );
  }
}
