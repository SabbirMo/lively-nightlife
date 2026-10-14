import 'package:get/get.dart';

class ClubPostModel {
  final String id;
  final String mediaUrl;
  final bool isVideo;
  final String caption;
  final String time;
  final RxBool isLiked = false.obs;
  final RxBool isSaved = false.obs;
  final RxInt likesCount;

  ClubPostModel({
    required this.id,
    required this.mediaUrl,
    required this.isVideo,
    required this.caption,
    required this.time,
    int initialLikes = 8400,
  }) : likesCount = initialLikes.obs;
}
