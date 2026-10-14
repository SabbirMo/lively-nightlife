import 'package:get/get.dart';

class FollowUserModel {
  final String name;
  final String username;
  final String avatar;
  final RxBool isFollowing;

  FollowUserModel({
    required this.name,
    required this.username,
    required this.avatar,
    required bool isFollowing,
  }) : isFollowing = isFollowing.obs;
}
