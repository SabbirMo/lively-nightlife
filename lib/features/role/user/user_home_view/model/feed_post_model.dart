import 'package:get/get.dart';
import 'comment_model.dart';

class FeedPostModel {
  final int id;
  final String userName;
  final String profileImage;
  final String location;
  final String time;
  final String image;
  final String caption;
  final String hashtags;
  final List<String>? images;

  RxBool isLiked;
  RxBool isSaved;
  RxBool isFollowing;
  RxBool showComments;

  RxInt likeCount;
  RxInt commentCount;
  RxInt shareCount;

  RxList<CommentModel> comments;

  FeedPostModel({
    required this.id,
    required this.userName,
    required this.profileImage,
    required this.location,
    required this.time,
    required this.image,
    required this.caption,
    required this.hashtags,
    required bool isLiked,
    required bool isSaved,
    required bool isFollowing,
    required int likeCount,
    required int commentCount,
    required int shareCount,
    required List<CommentModel> comments,
    this.images,
  })  : isLiked = isLiked.obs,
        isSaved = isSaved.obs,
        isFollowing = isFollowing.obs,
        showComments = false.obs,
        likeCount = likeCount.obs,
        commentCount = commentCount.obs,
        shareCount = shareCount.obs,
        comments = comments.obs;
}