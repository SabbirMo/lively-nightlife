import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lively_nightlife_nightclub_party/core/utils/constants/image_path.dart';
import 'package:share_plus/share_plus.dart';
import '../model/comment_model.dart';
import '../model/feed_post_model.dart';

class UserHomeController extends GetxController {
  final selectedTab = 0.obs;

  final commentController = TextEditingController();

  final forYouPosts = <FeedPostModel>[].obs;
  final followingPosts = <FeedPostModel>[].obs;
  final nearbyPosts = <FeedPostModel>[].obs;

  List<FeedPostModel> get currentPosts {
    switch (selectedTab.value) {
      case 1:
        return followingPosts;

      case 2:
        return nearbyPosts;

      default:
        return forYouPosts;
    }
  }

  @override
  void onInit() {
    _loadDemoData();
    super.onInit();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void toggleLike(FeedPostModel post) {
    post.isLiked.toggle();

    if (post.isLiked.value) {
      post.likeCount.value++;
    } else {
      post.likeCount.value--;
    }
  }

  void toggleSave(FeedPostModel post) {
    post.isSaved.toggle();
  }

  void toggleFollow(FeedPostModel post) {
    post.isFollowing.toggle();
  }

  void toggleComments(FeedPostModel post) {
    post.showComments.toggle();
  }

  void addComment(FeedPostModel post, String comment) {
    if (comment.trim().isEmpty) return;
    post.comments.add(
      CommentModel(userName: 'You', comment: comment, time: 'Now'),
    );

    post.commentCount.value++;
    commentController.clear();
  }

  Future<void> shareExternally() async {
    await Share.share('Check out this nightlife post on Lively!');
  }

  void shareInApp(String userName) {
    Get.back();

    Get.snackbar('Shared', 'Post shared with $userName');
  }

  void _loadDemoData() {
    forYouPosts.assignAll([
      _demoPost(id: 1, name: 'luna_vibes'),
      _demoPost(id: 2, name: 'party_queen'),
    ]);

    followingPosts.assignAll([
      _demoPost(id: 3, name: 'dj_alex'),
      _demoPost(id: 4, name: 'nightlife_88'),
    ]);

    nearbyPosts.assignAll([
      _demoPost(id: 5, name: 'miami_vibes'),
      _demoPost(id: 6, name: 'club_fanatic'),
    ]);
  }

  FeedPostModel _demoPost({required int id, required String name}) {
    return FeedPostModel(
      id: id,
      userName: name,
      profileImage: 'https://i.pravatar.cc/150?img=$id',
      location: 'Story Nightclub, Miami',
      time: '2h',
      image: ImagePath.feedImage,
      caption:
          'Last night at Story Miami was absolutely INSANE 🔥🔥 The energy was unreal...',
      hashtags: '#StoryMiami #NightlifeVibes #Miami',
      isLiked: false,
      isSaved: false,
      isFollowing: false,
      likeCount: 8400,
      commentCount: 342,
      shareCount: 189,
      comments: [
        CommentModel(
          userName: 'party_queen',
          comment: 'The vibes were INSANE 🔥🔥',
          time: '1h',
        ),
        CommentModel(
          userName: 'nightlifer_88',
          comment: 'Need to be there next time!',
          time: '2h',
        ),
      ],
    );
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}
